Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE81F2DD1F7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 14:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgLQNNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 08:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQNNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 08:13:05 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B6CC061794;
        Thu, 17 Dec 2020 05:12:25 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e2so20285821pgi.5;
        Thu, 17 Dec 2020 05:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cjO4VbjqTSiJSfh7o6HTbmhfPolYnzmH+2qlwgnhTqw=;
        b=gxnCOVNWi9imXkTxYIjwVGU5xF8sjdMZCE5U6lisgVWkM6+VpqRFZNvrxTxvfd0nJk
         KdFGLjZau47dBfaqQoz/+kPl1pc3yLD16uDFa7HSZK045GKCUnEE3YLjgHB6QTOxJBs+
         zePpCRLicUaeNTB1ZPXZvI3Lzb0xxECk13+txP6JgjkXvatf3KVqiKGDVnz+tm8IaiwW
         3tK+k6f7k4zsFkULZUyOSW83M0sptFyAVrsJdH+KC1t2LxTCa6ZGb8ewCCBOcovEoFSE
         04GWjE3h66Bp0ZRB32OSppswRIrIjaw4ARZZ5iM/XUaEx79OfNfvjNZPfLA16kPFhQGi
         zDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cjO4VbjqTSiJSfh7o6HTbmhfPolYnzmH+2qlwgnhTqw=;
        b=ibfIxdm7u1vlLSzK4evhStDpYZq52ag2L6a9NnpOfhE1FWotWW8brI4ZkQajxZtZE1
         ZCfDbnPrg7QNmz+PJr9DsnY7CAXTJTw+LrhiI+Wp7kKQFcJew5F2GX6ywT5HlOSEcJpS
         XtccG67VPTxGDov5yWbwGHXlODE8cjTyqKWpYnqxkkLO7nCBHTSPcBQDqYkdu6zFXKTr
         zRcQxCZq5rNadQNybIl3FkIPe5Jlz0V6GyVL3yP8dQoCqtcZDMLCRm09m/dOdAfvX+uf
         jW5tEIcV4QgSMwHGlxQUkwsx/y7oKMJpm0LDzc+mqctMzajxhGhM8UlH7vgT0CjATGut
         Z/5g==
X-Gm-Message-State: AOAM531ZpJHd7oxOZLosopVhD94Q4JoQ3WdjVKuHYa61vkoV/p7AFpZD
        KW/dCDSwkxZ6lAFhoR+HJ4mMN1dDWupPPQ==
X-Google-Smtp-Source: ABdhPJzUzGaZpaIf966PsS0EDcKHKhjFzIge4SuX+biz4WlhPzmivEWM/Abp9tmEgcIA3TQG4BINCg==
X-Received: by 2002:aa7:810a:0:b029:1a6:501b:19ed with SMTP id b10-20020aa7810a0000b02901a6501b19edmr15118104pfi.17.1608210744773;
        Thu, 17 Dec 2020 05:12:24 -0800 (PST)
Received: from [192.168.1.18] (i121-115-229-245.s42.a013.ap.plala.or.jp. [121.115.229.245])
        by smtp.googlemail.com with ESMTPSA id r10sm1179381pgs.49.2020.12.17.05.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 05:12:23 -0800 (PST)
Subject: Re: [PATCH bpf-next 2/2] net: xdp: introduce xdp_build_skb_from_frame
 utility routine
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com
References: <cover.1608142960.git.lorenzo@kernel.org>
 <9d24e4c90c91aa2d9de413ee38adc4e8e44fc81a.1608142960.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <434e65f4-0b29-3bfb-b5d3-7eebcdd791db@gmail.com>
Date:   Thu, 17 Dec 2020 22:12:18 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <9d24e4c90c91aa2d9de413ee38adc4e8e44fc81a.1608142960.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/12/17 3:38, Lorenzo Bianconi wrote:
> Introduce xdp_build_skb_from_frame utility routine to build the skb
> from xdp_frame. Respect to __xdp_build_skb_from_frame,
> xdp_build_skb_from_frame will allocate the skb object. Rely on
> xdp_build_skb_from_frame in veth driver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Thanks.
It seems you added missing metadata support in veth_xdp_rcv_one()?
It might be better to note that in the commitlog.

The code looks fine to me.

Reviewed-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
