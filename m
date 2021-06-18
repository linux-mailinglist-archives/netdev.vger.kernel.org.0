Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045673AC12F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 05:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhFRDIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 23:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhFRDIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 23:08:15 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22680C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 20:06:06 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so8312413oti.2
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 20:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tsp9Csffe0gvZqjH13JazO/4Y16vdBwzxe2e61mvlc4=;
        b=X5Mr/KWQ5KgcPmeNxJn5N3IkEjAskrzu1yXsT3hMfOgNAf81UDUksFBb3TOOdwQHKv
         rkAYbg4BqnZkdwxi7/zzYwHnOrU+w8xO7sVcTBQTGJqjXrqTMPErPO9zPu30I9S5c0h3
         W80YtctUGukjYwRKeEonLLOwqKJhdn103weczQlQuvlP8nlrjmPdDL3ifEW/fIhJhmRb
         cStUHgXYR6EbBGDPfzGLVzE769V9n3u5MV1ONlsxGNg0L9eQ2QZQjirhrwZOSiFVQ9Ig
         jfybbjA1aqsDmWeVArjzyIOi5gLsigjk/Rup96/yOodSHjU/uUrOf+xJkW/TrQbLzIEN
         SJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tsp9Csffe0gvZqjH13JazO/4Y16vdBwzxe2e61mvlc4=;
        b=aEQ5RonupTpDdo9BUMCxXsBWhp3b1x619rMgMY2v0jOW0qLkjx6QDL2mxSEoKtC4oq
         FHugcWaploxwMFS13FB1EEPgcgwdRyEY6wf5Zo85kD9fESZlSgcfXI8j/DkMkOfxDtqq
         FF5PpbgkkGU+dZrscazmgqjVrB48At3c6BtPa5/l0lsIFQux2SrfDDEvW2ILOJMje7u0
         Txeyel8lybygHr7dMdd6g9SSmch3l+kH+NZJdipcNUs8aYDbT8vV8VHSzFmCkDQl/FvI
         1JuWQeT4fZBVrZYD/h8CWnDy+JQ+/5CBja4jcGdlQAuxx6pgpxrk/u7yDddblUMmJzXw
         abQw==
X-Gm-Message-State: AOAM531uimsBq1ilXAsgYBTSvlxC6d6V6CBVqTauAT6Sad/CsVNvIAZE
        oGhVerV0DYztrMm2gIpXy08=
X-Google-Smtp-Source: ABdhPJwMFTGUhGYgkK60oRN39gbckk+QHuKdFiMQiA6ds7PbfPpu5dzgLazNd8F6Lx8O0QRddoN0ZQ==
X-Received: by 2002:a05:6830:2005:: with SMTP id e5mr7214593otp.215.1623985565606;
        Thu, 17 Jun 2021 20:06:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.44])
        by smtp.googlemail.com with ESMTPSA id l12sm1549158oig.49.2021.06.17.20.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 20:06:05 -0700 (PDT)
Subject: Re: [PATCH iproute2 v2] tc: pedit: add decrement operation
To:     =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>,
        netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210615164043.316835-1-asbjorn@asbjorn.st>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec57a9ad-68ee-44f4-95aa-491ba6d5bb3d@gmail.com>
Date:   Thu, 17 Jun 2021 21:06:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615164043.316835-1-asbjorn@asbjorn.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 10:40 AM, Asbjørn Sloth Tønnesen wrote:
> 
> In order to avoid adding an extra parameter to parse_cmd(),
> I have re-used the `int type` parameter to also carry flags.

just add the extra argument. There are not that many places that have to
be fixed up.
