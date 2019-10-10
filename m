Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B794DD2659
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387877AbfJJJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:30:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35631 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387727AbfJJJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 05:30:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so5995082wmi.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 02:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xw2OqBpr6JQo/dUUNepFw8saT6FZ2X+9TC5O/M6JiCc=;
        b=tsPN87qrb7SnXMfk9DsBmdwnImlZtp14YDyx9V4GNwQKfsd9RH3dVINK16uvjNJ3Mv
         sKHxsnIGvftheCQvCEixkQkt/nkSmenArp8+At1aENlH/OzLZB4yPcaG7XgGkw0As9QV
         ode/fKW1AJ0jYEEo5+6dek9GIAqTxV3Y4LI2PaMdK3NALKJcQ/82jWEd16K3YMCh7v5L
         d/MPAXgbVhIFFZrj6NQhRpABv/5XI9wVyQZlSssH3m+P15AO0k2f5B1tODqSFh+o8q+5
         ijQiAb4N9fXk5X6uM828NCHG3JK3mwOnAiDqWdnsHTxaIKQMkHNb5FZlVzYxuFRwDiGe
         d+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xw2OqBpr6JQo/dUUNepFw8saT6FZ2X+9TC5O/M6JiCc=;
        b=RmR+GYQT1TCDm02PYZpkMc3z4hRHDlyC6shTpnhU5QMtee4HK7hEifgEGzX7AS0Q6T
         R4HYjWXCSM9kKMYXRZ2c5dsZ8kxnijJ2uCy2NHkDSTp07XO0U5UGtG9Rhr9DBvdgqVGZ
         AxBrR5RvojMc14di7JLIJnx6haGeG1sJCiubIlnG8m5++ZENkb6SnPKmy0txTMF9DCZb
         IJK6wgelKkGE6za6+jb+5yoEgK+KGe0J3Rt8jtTMln5i6azn/NptygIN6DRhUIAeQ24i
         CQQ+hd2P0kAkW0zV8CtrRUWJBBgXWvM83EVgirNAfjdpLfh3gwolBZzllJ954EOhIyrN
         1owg==
X-Gm-Message-State: APjAAAWwt7+cKcQlAUwCxWhXzl8GSPk4drxYcsmFHvwMRx5MIsmaXRPy
        qrJtuWkzy+o2vlk/5N4iPZIWiw==
X-Google-Smtp-Source: APXvYqyM9PJg/Lp9na6scqs+npJ0qkkvg/faH56AjphsvyY492RXm4JJdP9hmlnb0uaKX+yaHyZTcA==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr6921856wml.58.1570699816416;
        Thu, 10 Oct 2019 02:30:16 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id e18sm6975329wrv.63.2019.10.10.02.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 02:30:16 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:30:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] genetlink: do not parse attributes for families
 with zero maxattr
Message-ID: <20191010093015.GF2223@nanopsycho>
References: <20191009164432.AD5D1E3785@unicorn.suse.cz>
 <20191010083958.GD2223@nanopsycho>
 <20191010091347.GA22163@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010091347.GA22163@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 10, 2019 at 11:13:47AM CEST, mkubecek@suse.cz wrote:
>On Thu, Oct 10, 2019 at 10:39:58AM +0200, Jiri Pirko wrote:
>> Wed, Oct 09, 2019 at 06:44:32PM CEST, mkubecek@suse.cz wrote:
>> >Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
>> >to a separate function") moved attribute buffer allocation and attribute
>> >parsing from genl_family_rcv_msg_doit() into a separate function
>> >genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
>> >__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
>> >parsing). The parser error is ignored and does not propagate out of
>> >genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
>> >type") is set in extack and if further processing generates no error or
>> >warning, it stays there and is interpreted as a warning by userspace.
>> >
>> >Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
>> >the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
>> >same also in genl_family_rcv_msg_doit().
>> 
>> This is the original code before the changes:
>> 
>>         if (ops->doit == NULL)
>>                 return -EOPNOTSUPP;
>> 
>>         if (family->maxattr && family->parallel_ops) {
>>                 attrbuf = kmalloc_array(family->maxattr + 1,
>>                                         sizeof(struct nlattr *),
>>                                         GFP_KERNEL);
>>                 if (attrbuf == NULL)
>>                         return -ENOMEM;
>>         } else
>>                 attrbuf = family->attrbuf;
>> 
>>         if (attrbuf) {
>>                 enum netlink_validation validate = NL_VALIDATE_STRICT;
>> 
>>                 if (ops->validate & GENL_DONT_VALIDATE_STRICT)
>>                         validate = NL_VALIDATE_LIBERAL;
>> 
>>                 err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
>>                                     family->policy, validate, extack);
>>                 if (err < 0)
>>                         goto out;
>>         }
>> 
>> Looks like the __nlmsg_parse() is called no matter if maxattr if 0 or
>> not. It is only considered for allocation of attrbuf. This is in-sync
>> with the current code.
>
>If family->maxattr is 0, genl_register_family() sets family->attrbuf to
>NULL so that attrbuf is also NULL and the whole "if (attrbuf) { ... }"
>block is not executed.

Ah, I missed that. Thanks!

>
>Michal
