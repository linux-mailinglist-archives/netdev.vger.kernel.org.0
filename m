Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58183EC3C7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHNQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhHNQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 12:23:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62561C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 09:22:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a8so19860425pjk.4
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 09:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VeVpUHuwbm4OQsPlaKCW4wcdB2n2uPm7yBa4B+zB1ik=;
        b=SN/d5ArtcqZaJHPJ3/97w8MSEXcgPS+p3EzgWz0veJyH9MduabEOfgeq49GoBbpG7g
         NOW3OsIT/DKA/hkXaNamALB3I5Vxq/VRemn4C9bXZuLDn+uCb63Fw9gyCZxyOTbV1HZ9
         n7Q/Ze+0I0ejVAfR/kWQqvFja5ehEB2TCcM+pBv4tLcIInJjxeyI2wbMa22lEMAYj7PW
         800IkD1IDAKlveeyhvcmhLr4OQ3SrL5wzaV9ThEUhKl6OUeKIaMC1ga0dBA/ewo/WAkd
         ok6yhj/vLvLf8DLXjpWOnpvjI4h0c/WExYpSlCdtEaVRm3AjJDDixNVHptRdq/hOpbfr
         dYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VeVpUHuwbm4OQsPlaKCW4wcdB2n2uPm7yBa4B+zB1ik=;
        b=Bhw+lodnLwvpE9NcwjgOjgPNLHp2WGIAnXTNNexLwBPiQ2BJ4JyQYELUFfUwuegjPX
         +NaSqZ7/lAK5QJQU4AMnk0CffkTmmgmFn8Vu2ewtvF6aebM0iVu5+jutbsadkegx+QcI
         ecVe6ZLEIBvABkF6yld34VOIsOUMVGX92YwOTpcnywF11RVwfKR7dqKhEFaPQWQqS17p
         XlJCyDhOLr8KulKAoebSdMMmFIJbiP5MN9azYMeOGSDbkUtD34Bs9eLpWuM/we/R4r79
         0R/kWraYGnwHMb3JuFUigmBIKyfx6X7TIt7UxM5oVjbxxg5lgXF83ukaDLf0NheGnSOe
         4vvg==
X-Gm-Message-State: AOAM531kZHhuROrJcHesojhxtPrK0vYQyVa7sAImFsgnprWWxyhCn7nK
        Y4NctuVntQw2kXX007w9uYiCSw==
X-Google-Smtp-Source: ABdhPJxfHeg3cDHzjoq3rVttTLi3B/bti8jV0rzUPN+5UKhdF1paiAuG3MvxL3DYLPT4cRtW082lfw==
X-Received: by 2002:aa7:800e:0:b029:3a9:e527:c13 with SMTP id j14-20020aa7800e0000b02903a9e5270c13mr7779479pfi.42.1628958154831;
        Sat, 14 Aug 2021 09:22:34 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id c26sm7082423pgl.10.2021.08.14.09.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:22:34 -0700 (PDT)
Date:   Sat, 14 Aug 2021 09:22:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Gokul Sivakumar <gokulkumar792@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 2/3] bridge: fdb: don't colorize the "dev"
 & "dst" keywords in "bridge -c fdb"
Message-ID: <20210814092231.23513631@hermes.local>
In-Reply-To: <20210814095439.1736737-3-gokulkumar792@gmail.com>
References: <20210814095439.1736737-1-gokulkumar792@gmail.com>
        <20210814095439.1736737-3-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 15:24:38 +0530
Gokul Sivakumar <gokulkumar792@gmail.com> wrote:

> +	if (!filter_index && r->ndm_ifindex) {
> +		if (!is_json_context())
> +			fprintf(fp, "dev ");

This looks functionally correct, but please use:
            print_string(PRINT_FP, NULL, "dev ", NULL);

The reason as part of the json conversions I look for fprintf(fp
as indicator of unconverted code.

