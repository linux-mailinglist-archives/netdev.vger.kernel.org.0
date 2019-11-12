Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB132F9434
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKLP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:27:36 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:39100 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfKLP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:27:35 -0500
Received: by mail-il1-f195.google.com with SMTP id a7so15442865ild.6;
        Tue, 12 Nov 2019 07:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MpymBe9XsQT1dS+UbhPjtN/MblGXirGawihya0jKgPs=;
        b=hDjMTzDPXNiJpMQgFJFOSQsVO+1E6Pj0NGG116eVdPAREYNtM4/R9YAEnGJoD8qBSS
         4lAPvnGEatr2O8xzEWY5OaLtNYc3tfhYCPxYHJ+96vbvHDDjQGiN0vZX1c1ccWCb/ZoN
         aaetvZJ65IKz66eT+y03do5rTHfhdWAhPUY5bC/FFPgCAGOZ4TT+ckVmGkEGf9vNRLcp
         d00NpzbPBGWYxKrMHR/++4dliFWwr6mS8Mflixja9r20ZO6MDyoKR8u6T6xJSN7cKafz
         lP7Ss0R+b85bh+y+bAPyI1W5i0l/NfSZlo1WIUvaXVLNukUS1KP793ukOos0f7b4oPP5
         R0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpymBe9XsQT1dS+UbhPjtN/MblGXirGawihya0jKgPs=;
        b=BtoYvv0WNQgCL7TjtUWfoxGw4U3ihstwJfqAAcfmKKJqI6yzeGvYIrvyhWwzdnvm/J
         WVI5m+c6+5jeqMUxSawDRvpaNogsdZV+O0w3dWVutKAUogtmgziqNPG1jnOW2Cb8iBcc
         eZSMPTfMmWugQwpSSTH96ZWkVBwfprxFed7QOwwXSwkI4p8TdPj9hinRwf9++F8rYqxA
         1jetmIxFJGu2g+QqtmuQJCWSRlxaP3Vdoh+t8ekB6YsIHWL1zGUDJ/fWq51I9mzYJOTP
         nhy1SLGJsFtbAERzHSUcomyx8ltZvTdqGvIIA9KqgF+t/X66mC+bXmBrp8BN8RYZMOFr
         ZWwg==
X-Gm-Message-State: APjAAAUTmT34hCrD/vDGwFC2AAQ+OcRTdFOx2Ttpuaxn6SoCO8QufA5L
        wiQPNYyi1SZwbU2ytj+AVu8ZRXky
X-Google-Smtp-Source: APXvYqysdGik8YWhZRoGAvybGTd0EK7TyK5C+YDUaZ3RSwqbsJNoArWaCCdXbyvSREZbJYIca9KYPA==
X-Received: by 2002:a92:1b49:: with SMTP id b70mr35879042ilb.180.1573572453629;
        Tue, 12 Nov 2019 07:27:33 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:f828:9329:851c:5f36])
        by smtp.googlemail.com with ESMTPSA id n20sm2009876ilj.23.2019.11.12.07.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 07:27:32 -0800 (PST)
Subject: Re: [PATCH v2 2/2] net: add trace events for net_device refcnt
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net
Cc:     xiyou.wangcong@gmail.com, eric.dumazet@gmail.com,
        shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191112130510.91570-1-tonylu@linux.alibaba.com>
 <20191112130510.91570-2-tonylu@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea3bf073-68af-d899-2664-fef54953a68d@gmail.com>
Date:   Tue, 12 Nov 2019 08:27:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191112130510.91570-2-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 6:05 AM, Tony Lu wrote:
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 3b28843652d2..3bf6dd738882 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -326,6 +326,47 @@ DEFINE_EVENT(net_dev_rx_exit_template, netif_receive_skb_list_exit,
>  	TP_ARGS(ret)
>  );
>  
> +DECLARE_EVENT_CLASS(net_dev_refcnt_template,
> +
> +	TP_PROTO(struct net_device *dev, void *location),
> +
> +	TP_ARGS(dev, location),
> +
> +	TP_STRUCT__entry(
> +		__string(	name,		dev->name	)
> +		__field(	int,		refcnt		)
> +		__field(	void *,		location	)
> +	),
> +
> +	TP_fast_assign(
> +		int i, refcnt = 0;
> +
> +		for_each_possible_cpu(i)
> +			refcnt += *per_cpu_ptr(dev->pcpu_refcnt, i);

Rather than copying the definition of netdev_refcnt_read here, so just
use it.

> +
> +		__assign_str(name, dev->name);
> +		__entry->refcnt = refcnt;
> +		__entry->location = location;
> +	),
> +
> +	TP_printk("dev=%s refcnt=%d location=%p",
> +		__get_str(name), __entry->refcnt, __entry->location)
> +);
> +
> +DEFINE_EVENT(net_dev_refcnt_template, net_dev_put,
> +
> +	TP_PROTO(struct net_device *dev, void *location),
> +
> +	TP_ARGS(dev, location)
> +);
> +
> +DEFINE_EVENT(net_dev_refcnt_template, net_dev_hold,
> +
> +	TP_PROTO(struct net_device *dev, void *location),
> +
> +	TP_ARGS(dev, location)
> +);
> +
>  #endif /* _TRACE_NET_H */
>  

The location alone does nothing for resolving reference count leaks; you
really have to use stack traces to pair up the hold and put and to give
context for what are repetitive locations for the hold and put.
