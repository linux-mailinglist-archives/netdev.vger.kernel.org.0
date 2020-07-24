Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EAD22BD8E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgGXFfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:35:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7AAC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 22:35:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc15so5347917pjb.0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 22:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=770/sglgm0aiJbros+faVJpKgVYS5iJORcc+kKn/uJA=;
        b=XeAMAqBZoqx6UgAURDAfVmqNQTkM05dOCPSd0xiWrnuW9NTBweje+cHre9uAvyXR7q
         oRwasN4ALoOZ/whNtnYVHuq6AVo6ikxNa8Z3PQBkQf1VsY7OV+ZYuF2Co2qm0Plhi8oq
         zy8ay8sDLtve+/YVSb8ZNmW3BhP7U3jeJAmXmp9baHRjLBOKDehnALrj2bmwJMX2Bebm
         d4XYKQiZ+40VnSryGxEzSxQswMCQ4u4ZAgeQ2unFAc+1NdzyEXzpgoXF+Ab0mTYntfgd
         eD8XBMg8bKH4+kfV9fWiSiYXvJYpFnJuDMTGLF87VsVzG1N8sPeJdnTzYsmw8k3iV5Ej
         SyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=770/sglgm0aiJbros+faVJpKgVYS5iJORcc+kKn/uJA=;
        b=mrcpf8QLMJidpkcZKRvWebTCkaq4OplZi1kR5RtLYXwPtNomMJ/dQ7cPs9StFLOSxO
         WU2/YaX19k+J/Taiw1ZLh3m+5LnB2OhhP9wpAlJ2Z5/uDbzkKwDKHu6sBEOH7kRnHxEl
         bXXsVMRsKkXb4G0ISFqRb+CrOuwAyWP5gzHpYUzJHgqDaKHI3htvPHSs7tVAg/F6ro5l
         kOJS3Tg3O10Cc7IJYCUt5Wu264VgQR4u/mgIsZ4ptj+Q5qXPkFUOMnb8AOH9JsaqxMVN
         zHORMWpmwN+ihMpNxqAtFSK7nC2xHxlBU2OiBNxDiY7GvIYBuihQ0shGGgwO6RdR+iwe
         ZTNQ==
X-Gm-Message-State: AOAM5339FM3efPMc+NkbynoNC3OVgzkhGsJYHSJfbNJVJNoo6Q1oTbyX
        nUyF0pkn4OtpvDK5OysbZuM=
X-Google-Smtp-Source: ABdhPJyJymt6+pgcgEBvZUv+g/P364R42Up2VgtX1BOY+D8bYO/ikBHz/FwilxQkbTBl9SD6vMuHew==
X-Received: by 2002:a17:90a:1a83:: with SMTP id p3mr3502171pjp.113.1595568911365;
        Thu, 23 Jul 2020 22:35:11 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s14sm4814660pjl.14.2020.07.23.22.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 22:35:10 -0700 (PDT)
Subject: Re: [Patch net] qrtr: orphan skb before queuing in xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20200724045040.20070-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <590b7621-95bf-1220-f786-783996fd4a4c@gmail.com>
Date:   Thu, 23 Jul 2020 22:35:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200724045040.20070-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 9:50 PM, Cong Wang wrote:
> Similar to tun_net_xmit(), we have to orphan the skb
> before queuing it, otherwise we may use the socket when
> purging the queue after it is freed by user-space.

Which socket ?

By not calling skb_orphan(skb), this skb should own a reference on skb->sk preventing
skb->sk to disappear.

It seems that instead of skb_orphan() here, we could avoid calling skb_set_owner_w() in the first place,
because this is confusing.

Also, there seems to be no limit on number of skbs that can be queued, this looks rather dangerous.



diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 0cb4adfc6641da0b1add7a8b40957fd23df1e075..9b180768dbfe9ea100ad008d92522e340f73101e 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -661,7 +661,6 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
                pkt->client.node = cpu_to_le32(ipc->us.sq_node);
                pkt->client.port = cpu_to_le32(ipc->us.sq_port);
 
-               skb_set_owner_w(skb, &ipc->sk);
                qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
                                   &to);
        }
@@ -855,7 +854,6 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
                skbn = skb_clone(skb, GFP_KERNEL);
                if (!skbn)
                        break;
-               skb_set_owner_w(skbn, skb->sk);
                qrtr_node_enqueue(node, skbn, type, from, to);
        }
        mutex_unlock(&qrtr_node_lock);


> 
> Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
> Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/qrtr/tun.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index 15ce9b642b25..54a565dcfef3 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -20,6 +20,7 @@ static int qrtr_tun_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
>  {
>  	struct qrtr_tun *tun = container_of(ep, struct qrtr_tun, ep);
>  
> +	skb_orphan(skb);
>  	skb_queue_tail(&tun->queue, skb);
>  
>  	/* wake up any blocking processes, waiting for new data */
> 


