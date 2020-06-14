Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B51F8AE0
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgFNVXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 17:23:53 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:43946 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgFNVXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 17:23:52 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05ELNUUM015920;
        Sun, 14 Jun 2020 23:23:36 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id C578E120925;
        Sun, 14 Jun 2020 23:23:25 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592169806; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kx73yPN0vHM7ch4flQNK0LbOwii+DIdepw9ya6KsG+4=;
        b=hr6ecuOmuCy65Cu//Kz5PKqgoWwK18CtiSwbd3ekSmtPTBr0ayjSvsPwYRDWj4thSht3kS
        aM4h2kwUg0A0+eAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592169806; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kx73yPN0vHM7ch4flQNK0LbOwii+DIdepw9ya6KsG+4=;
        b=fWHiesOOVizZ9H6kBsUBuxcVJ2X5IdMsXdzmyNaa9T6SeSKjwdKldtJdXKUhqoLNUNleJr
        2tRXIcPr/1DywcBe4UW2gFdjXqO2qS3XSQtSUD/oRz7jrnHyLXTt1WsSBzPGbYyaw/a0wd
        QOg+INcESm9G0grvRj+iR9KArQQeZIOHuSTw2cOlqLBQ0MUGwUzfg2TNvNJNqBfKb3MWCT
        BvQg7aS6rjPTPyzwgB3LJhOTbynxHLw5w+phsogazf+4ptYusW+T75Jn+An5Dspd7TsnKo
        gma3ea1o0O70GPnt3vcIvLpnb5cq/kby0Ou6H/wwpK/IIIvwZ7vZtZ8JRq+r5A==
Date:   Sun, 14 Jun 2020 23:23:25 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC,net-next, 2/5] vrf: track associations between VRF devices
 and tables
Message-Id: <20200614232325.c710c9c2e71f66202b51ee46@uniroma2.it>
In-Reply-To: <df8e9f2a-6c39-a398-5a44-5c18346f7bdc@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-3-andrea.mayer@uniroma2.it>
        <20200613122859.4f5e2761@hermes.lan>
        <20200614005353.fb4083bed70780feee2fd19a@uniroma2.it>
        <df8e9f2a-6c39-a398-5a44-5c18346f7bdc@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Jun 2020 18:34:25 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/13/20 4:53 PM, Andrea Mayer wrote:
> > Hi Stephen,
> > thanks for your questions.
> > 
> > On Sat, 13 Jun 2020 12:28:59 -0700
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> > 
> >>> +
> >>> +	 * Conversely, shared_table is decreased when a vrf is de-associated
> >>> +	 * from a table with exactly two associated vrfs.
> >>> +	 */
> >>> +	int shared_tables;
> >>
> >> Should this be unsigned?
> >> Should it be a fixed size?
> > 
> > Yes. I think an u32 would be reasonable for the shared_table.
> > What do you think?
> > 
> 
> u32 or unsigned int is fine.

Hi David,
I will use the u32.

thanks,
Andrea
