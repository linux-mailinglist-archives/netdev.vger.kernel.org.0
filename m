Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9733BF6E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCOPJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhCOPJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:09:16 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42881C06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:09:16 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id y131so31930052oia.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TdKUa2IM2JV81AEwjf3Spx674zXNg/YcJmhmWXyp2go=;
        b=DDsd6WwFFP5zqPXINVqxNrgn9TE3R1P34XPiA/PTZmsE2X3NLWncS/c3UA6mozlubH
         F5WMqKTmUWrCA6b/kRGpH5DTqK2128/ZmuRYQrhqR39ZTWPF+zeug7np89pZTpxKQEYe
         CsZgY6TSa+BaJDYRtlJZdAFMPaY3Z5fsU4lL03Z/VrYU0Rngd/yT78KhVo/jP12x84mw
         bhpQKCYI/RRtrR5dxUJszASOPLrMTi8Oa5KY5w1PQ0eQKM19MRkCbBmgtitAEIIC4pWi
         Bqfg7JtlgyuUp0m10yfcqKoc6xo/fzR7jdmrxfyYWIniERaUOCARiQR7dhzKHuaOP2Xp
         BNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdKUa2IM2JV81AEwjf3Spx674zXNg/YcJmhmWXyp2go=;
        b=Mo+Qp83pmQEbXxxUAA9VkZGX+qVvPNqkyQQdRJc4JqsCIK7Zu3kziF2hPJiwI2Qztw
         fhwquDa1GzHg1FhBVo7ntKl5fW4sZODZuEp6uTHXT0pRePt0AG6Iou4VCfBAKa9xk/Gs
         /sh+nQvAjuN+FZ+9cyIst9fKgR5HY5TVuIHThHAxO+T+B9PBsTr0Srmt9m/+UHSWDvAw
         8AAbU0huswvaOIdBLVDn0ao99hQPYdNBQaLpY+FdDPFk+Unz/yuhQtmcHzCg9B2rbq6J
         kE+z2InXUH+HAzdMEKTtcSyy4MCx5AZ6CUUoj28c8GsG+wtS1KPGJhD7J67MyHEetHhT
         D4cg==
X-Gm-Message-State: AOAM5336WsyNAKdqNnOHbL0seIYFhyh5MPEoktSfpFME2lbeFn6qObeY
        VVj2hycT9vtee++oK5bOy7k=
X-Google-Smtp-Source: ABdhPJw/07/8usBW1O0LKtOhtLu6fGCzaR7emLDW1FYWz/fnpGgD7UwyAz7iIl6ajHXTOKamvZYi2g==
X-Received: by 2002:a05:6808:ab0:: with SMTP id r16mr6208867oij.34.1615820955744;
        Mon, 15 Mar 2021 08:09:15 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id u23sm6053299oof.17.2021.03.15.08.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 08:09:15 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] dcb: Fix compilation warning about
 reallocarray
To:     Petr Machata <petrm@nvidia.com>
Cc:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210222121030.2109-1-roid@nvidia.com>
 <875z2kl1yt.fsf@nvidia.com> <87v99sh8az.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c919ad36-e852-96c9-5ba2-f1601e18fbdd@gmail.com>
Date:   Mon, 15 Mar 2021 09:09:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87v99sh8az.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/21 7:10 AM, Petr Machata wrote:
> Could this be merged, please?

done
