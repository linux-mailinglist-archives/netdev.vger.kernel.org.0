Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B41972A
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 05:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfEJDfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 23:35:07 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38025 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJDfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 23:35:07 -0400
Received: by mail-ot1-f68.google.com with SMTP id s19so4331438otq.5
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 20:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XPpYtJgHXSQwbz+WHen0CqKIs5Q0YuIxYrIfRoFSBCA=;
        b=wCHiv/RClUDDN4oNm5RNz+SvY1loFX6IVul0ucFnke/hBZ8Ew0MtC8kstILy3DvV7X
         oUai/lYQ3yb2nqW5fs7t3mKjWf61fIP/mpwdFa4zL+bmzwUi5Ef/PQ6jW4wt+O6kyRXP
         7jbJYi3XVyaojPlSUGU5pnyZ4fiYXG4QNcMSoQaJ7OVsADh2AFBK4Z5kXE1bpjpzEFP9
         EH37gtTqTkaj8JoThRlvY6unglTIBVmYbfINEOhSy+/fXNj+45ZioT5/3z0eEr41WHdK
         65o8TBSV+3Kn/vhwuKtUQdIwiRdVhKHdw8uhXVt0CsyHPK6WxuSpLH73ozIDDLFZZJTP
         v1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XPpYtJgHXSQwbz+WHen0CqKIs5Q0YuIxYrIfRoFSBCA=;
        b=oshUOyF7V/PROkAR1o5YvP8cd2hUwY8RF8tjHfy7kJCNZ8O0Ecx0hhEFP+RSbPnI+U
         SDsk4U9K/6eiBcW0LJjLoJz/GJ76MaBVaRPzMtayNBLkzY7NMlOMZ0/VCQzisJM3v2GP
         P/N2WyHMHfZqOE9kWZjp6XDuoTO2oXaHXz1w1Tgy/4duJ5xKM3wyU5cZrjeWJUJUV2VI
         ByfzeTkLA/B/VXuYg1vbHrP8FBzGnye9iQ3FoBxAzCRlwIPXWQsmXtutSq8q85AKEvzF
         GAeIWFSRJQdmp0neyZc0p8ZqNFoilJUgsi7eI12x5/n2REftiIoOMA+A9TnB1oKC2VxR
         PTVg==
X-Gm-Message-State: APjAAAU8uoMGCFc2YtF1JZZBPQseQ2PYd//YAEw8T4ug+WjDMK24NhDX
        gxd62zkfD4s2ytnKX/jo88zmrw==
X-Google-Smtp-Source: APXvYqy3IwF4pzgdJMDBDlSV2/ISblLb1we2tWFBUVkjeV+1cTVKhZmaYnIZU1ala2Gj+o3kEhOYaQ==
X-Received: by 2002:a05:6830:2003:: with SMTP id e3mr5447421otp.142.1557459306213;
        Thu, 09 May 2019 20:35:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r65sm1704841oif.47.2019.05.09.20.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 20:35:05 -0700 (PDT)
Date:   Thu, 9 May 2019 20:35:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] bridge: Fix error path for kobject_init_and_add()
Message-ID: <20190509203501.310a477c@hermes.lan>
In-Reply-To: <20190510025702.GA10709@eros.localdomain>
References: <20190510025212.10109-1-tobin@kernel.org>
        <20190510025702.GA10709@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 May 2019 12:57:02 +1000
"Tobin C. Harding" <tobin@kernel.org> wrote:

> On Fri, May 10, 2019 at 12:52:12PM +1000, Tobin C. Harding wrote:
> 
> Please ignore - I forgot about netdev procedure and the merge window.
> My bad.
> 
> Will re-send when you are open.
> 
> thanks,
> Tobin.

That only applies to new features,  bug fixes are allowed all the time.
Also please dont send networking stuff to the greater linux-kernel mailing list.
