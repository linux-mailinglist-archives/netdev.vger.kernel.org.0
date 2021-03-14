Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FAA33A4AD
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhCNMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhCNMTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:19:09 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48DFC061574;
        Sun, 14 Mar 2021 05:19:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jt13so61747104ejb.0;
        Sun, 14 Mar 2021 05:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=q878vqPaFdQsV7G5cUf5KWZha9MQGP4Zu9XCF3Zzrww=;
        b=V4meSn09NfQ6e8oh3hoVuO/1LHbW0ZidqrcSYPKxk5chfl5vr2XdKL09WYaOJMlQCO
         871OFrhQfE55i3nRlavweQIGgqT/krIPAnwBTVc060AmdvdSVm2aQ3nRPEoviZNYB54k
         DhKRnUjqhT+2Sluhh5HwdVHl9dKEC0hHV4iwlr+lz8OCV2dDrtAC941sdPRPxkk6SkUb
         R5D0djf5CKaTR8CrXtiCry8EOQ37771qmK6Jxl987cywWOosI191nGZR9YouRTRLvXF0
         O6xmhETKkORFthsRW01FGpIXLTU3ZxIqtySuJetHcN4SO4xTXfIXNmOGO+K1f73o2xk4
         jRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q878vqPaFdQsV7G5cUf5KWZha9MQGP4Zu9XCF3Zzrww=;
        b=XoME/AjVbYWBRMQHjGJvfNjfkHmAVENtXPkeqvHxjWKQV0QyQKROAXLrjPsS1ma+FG
         tS1rXOqeYZSdl32LZsnqdNcrV4bddy5Rhy6G/33UsSFfuA5BzUfnICBngiCS4iap/5mt
         mSeA92XQIf9t4QqoiqY/vZOLU2BQde/V/+vQyo15zNSv8JRjt1BhqwiE8xAgH7/Ja3QH
         +x6GBqfUgJf+JA0uhUzoPeyxdDidW7J3U6M3lqA3+XNxicKW9wIxEpUGQYLVWvAuBdxE
         EPkeaRkPKpd7mygexOgwx1sQ6jE+1b35XTsdRBSpG8awFd8sGnOgjMRZp98I17LLsKDM
         BCTA==
X-Gm-Message-State: AOAM530DIaFfDiLvy8uDOgthBQ2kT81eW8v2oxLpH5w7W0HmDFRsvLjz
        QNmnpZ+AMQseLTHbgf/Trgs0id0WFNZmsrE9
X-Google-Smtp-Source: ABdhPJz6+irM/7cwaxZM44ih8oze33caTttSKlQn6Gp5ovWyL5rb3Z4CGM+nntrkGJi2rDhamD1orA==
X-Received: by 2002:a17:906:4410:: with SMTP id x16mr18553102ejo.446.1615724347513;
        Sun, 14 Mar 2021 05:19:07 -0700 (PDT)
Received: from TRWS9215 ([88.245.22.54])
        by smtp.gmail.com with ESMTPSA id s11sm6206451edt.27.2021.03.14.05.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 05:19:06 -0700 (PDT)
Message-ID: <b1b796b48a75b3ef3d6cebac89b0be45c5bf4611.camel@gmail.com>
Subject: Re: [BUG] net: rds: rds_send_probe memory leak
From:   Fatih Yildirim <yildirim.fatih@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date:   Sun, 14 Mar 2021 15:19:05 +0300
In-Reply-To: <YE3K+zeWnJ/hVpQS@kroah.com>
References: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
         <YE3K+zeWnJ/hVpQS@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-03-14 at 09:36 +0100, Greg KH wrote:
> On Sun, Mar 14, 2021 at 11:23:10AM +0300, Fatih Yildirim wrote:
> > Hi Santosh,
> > 
> > I've been working on a memory leak bug reported by syzbot.
> > https://syzkaller.appspot.com/bug?id=39b72114839a6dbd66c1d2104522698a813f9ae2
> > 
> > It seems that memory allocated in rds_send_probe function is not
> > freed.
> > 
> > Let me share my observations.
> > rds_message is allocated at the beginning of rds_send_probe
> > function.
> > Then it is added to cp_send_queue list of rds_conn_path and
> > refcount
> > is increased by one.
> > Next, in rds_send_xmit function it is moved from cp_send_queue list
> > to
> > cp_retrans list, and again refcount is increased by one.
> > Finally in rds_loop_xmit function refcount is increased by one.
> > So, total refcount is 4.
> > However, rds_message_put is called three times, in rds_send_probe,
> > rds_send_remove_from_sock and rds_send_xmit functions. It seems
> > that
> > one more rds_message_put is needed.
> > Would you please check and share your comments on this issue?
> 
> Do you have a proposed patch that syzbot can test to verify if this
> is
> correct or not?
> 
> thanks,
> 
> gre gk-h

Hi Greg,

Actually, using the .config and the C reproducer, syzbot reports the
memory leak in rds_send_probe function. Also by enabling
CONFIG_RDS_DEBUG=y, the debug messages indicates the similar as I
mentioned above. To give an example, below is the RDS_DEBUG messages.
Allocated address 000000008a7476e5 has initial ref_count 1. Then there
are three rds_message_addref calls for the same address making the
refcount 4, but only three rds_message_put calls which leave the
address still allocated.

[   60.570681] rds_message_addref(): addref rm 000000008a7476e5 ref 1
[   60.570707] rds_message_put(): put rm 000000008a7476e5 ref 2
[   60.570845] rds_message_addref(): addref rm 000000008a7476e5 ref 1
[   60.570870] rds_message_addref(): addref rm 000000008a7476e5 ref 2
[   60.570960] rds_message_put(): put rm 000000008a7476e5 ref 3
[   60.570995] rds_message_put(): put rm 000000008a7476e5 ref 2

Thanks,
Fatih


