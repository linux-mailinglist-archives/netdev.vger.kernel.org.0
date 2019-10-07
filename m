Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08812CEEBE
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfJGWBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:01:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32782 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfJGWBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:01:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so9551316pfl.0
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 15:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b1vxt3BHAdtVsNVcsaK+SHT0PO5pnrGIy4GUYFy07FQ=;
        b=fN+AY2T0tU+a7p72Bps1sLCgivXpambggMKUJhYUIUCIfLaRXOCfAzEWLHHp8OWV2c
         Yd0R/D0gxHvsUWpiXDLB66UWZidavR9/9V8YBdcg1FeB0Mi6V9OjBLuiRGeMBF9hj0kG
         MXjqAgx0m3BbbtDNA8UX1g04D5uDNdiPSEFWlsnhcjr6WKs6Q7JKS22AVC4R44QbRIou
         JA6RGCp+Wa3BQOkHNJP92RTq1zsL46NVSKzHo4m4V3aleuu95mjrV6NTbOwgSXeeVlzQ
         IDDSahcrhlV5HTTSHjVlrFP/p1ERWXAhq94VjlbjH6WAsWjQRGOIZGGhayn5M/o4bfWy
         Anng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1vxt3BHAdtVsNVcsaK+SHT0PO5pnrGIy4GUYFy07FQ=;
        b=YGXvzOq6lCGTIFnqPbAM78qzszwv5gFrEhJJQaiepCThBv0cfvpW6VjdvxXdDf98ix
         04pLm8lya7WLr5oA5p/GsFhB9smO3qz6Ym0OVxMw+JsUj/eu6XQitaSIWGe+kULIY2qg
         tBgRodB5rS4QoTwuXemavO+bqOp/xEYv5TWWgfYiJHLd4Qn+95cHp9SgF0xYXYzhQRrJ
         db+jntJ+J16+fovEXS18pzxfAmfd5w5ZJMkz3f6FtPGSpPuzjLZ0zAaKMukytLAL2GrL
         +A+fhUoH89wEXronWjtb426Up9uyC3sYW+u3qKl3PhzT734jcnEsHml0WK+iU0tHVp+T
         8PzA==
X-Gm-Message-State: APjAAAXNDY9XbHWFxY1yuOKlQK44pUy2WS/zR/D6rV48B3yV6vslxCS1
        uQc6vNnAljUGwuxslz7C5cs=
X-Google-Smtp-Source: APXvYqxDxeJnNfjL5oK1chf0iijUhGMtJUBVCKc+hmjoTw1rNQe06kXtWqn37rMcPSS/NMCLaZZF+w==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr1664114pjt.122.1570485703729;
        Mon, 07 Oct 2019 15:01:43 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:dc58:1abd:13a8:f485])
        by smtp.googlemail.com with ESMTPSA id l1sm467324pja.30.2019.10.07.15.01.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 15:01:42 -0700 (PDT)
Subject: Re: [patch iproute2-next v3 1/2] devlink: introduce cmdline option to
 switch to a different namespace
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
References: <20191003094940.9797-1-jiri@resnulli.us>
 <20191003095115.10098-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8206fd09-08bd-f392-d550-9995c773e130@gmail.com>
Date:   Mon, 7 Oct 2019 16:01:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191003095115.10098-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/19 3:51 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Similar to ip tool, add an option to devlink to operate under certain
> network namespace. Unfortunately, "-n" is already taken, so use "-N"
> instead.
> 
> Example:
> 
> $ devlink -N testns1 dev show
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - added patch description
> ---
>  devlink/devlink.c  | 12 ++++++++++--
>  man/man8/devlink.8 |  4 ++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 

applied both to iproute2-next

