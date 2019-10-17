Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34521DB172
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393632AbfJQPrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:47:48 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40839 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388974AbfJQPrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:47:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so1907565pfb.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RHyZYAsncwO+1y3gT7p2kMm026xbVHy1Bz1QKVwtduw=;
        b=dAqxCBcgExWa9d/zXtebu/wc8XkmW9tWdF82oFnqCZR2Es8twMiKkrirmiQwjRn/8L
         QdQ+WbvwDET5R9mk1bcvsLcCUBdJ+8NG3vnrfUOZNpW3bz8ezax8GyuMrt06yacVoH/S
         rQpghiyy0p/elKkZRl3Xurxq8e4aiINYRyq1ILf4Wl1ywsQrOSZrTspb02e/Gez4Kn1O
         AoWCPQLrYoTWmKNInqWJKxc0AHqNwIJAvFVxX0AFWvM2vVZkGnz7p6TZgIZFtQZbAAkP
         XtFue3lYGhIYhIW0IThMugWjdKukXm/diiFnapRhOwsncxld3zzwuQqnvy5ZtCPEeh3f
         R+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RHyZYAsncwO+1y3gT7p2kMm026xbVHy1Bz1QKVwtduw=;
        b=rAD1siDIDPehyJ2gswqy9trACJcMIu9pYcTLsmA9UZqJfeZNTxxA4iVf09t6Vif70u
         BihaKbWr/1n8mKIVV6MQjbkwBhgQbm0+J1tzrBst6o/kx4oNatCPZIlNXaWsqHW4H4qb
         ZyzbEjZGWavz+CWn45sZM7JEzIJOgC+bvkMtCrRTejcL/26jxQZfTQzlpdwDt6oIBs+m
         qwmitjm5JE7ksHIUjMXTeYueC638npGAFaaEizMNXfXHpscOxLEI9UgTaVWFxYSyk2k6
         qr0exWmMU0aTqGviXTes6xbyoLUlyoUsIvVv6GhU0VeKR5jIM4CwJ3f+LZWdHIGGsved
         ho+w==
X-Gm-Message-State: APjAAAV1EgOHtkirH9KGE/QfdmOHjlCfqr2bybvB0p7+rFouZda3V5U3
        lgTU9SC33uNZOIKh/0RtQcpYBGpi6ms=
X-Google-Smtp-Source: APXvYqzaiwFpMLi7/mP+QP4mSVnfKtonlpByAzTy67XnrO4kd6FegbAEBo7+1C75ocpNjMK8sA0GLQ==
X-Received: by 2002:a63:5ec6:: with SMTP id s189mr4763645pgb.185.1571327267773;
        Thu, 17 Oct 2019 08:47:47 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id l22sm2596138pgj.4.2019.10.17.08.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:47:47 -0700 (PDT)
Date:   Thu, 17 Oct 2019 08:47:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
Message-ID: <20191017084743.1a5875ff@cakuba.netronome.com>
In-Reply-To: <d76b854c-5f6d-27b6-d40e-e3c0404b5695@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
        <20191016101943.415d73cf@cakuba.netronome.com>
        <20191016.135003.672960397161023411.davem@davemloft.net>
        <d76b854c-5f6d-27b6-d40e-e3c0404b5695@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 11:27:09 +0800, tanhuazhong wrote:
> On 2019/10/17 1:50, David Miller wrote:
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Date: Wed, 16 Oct 2019 10:19:43 -0700
> >   
> >> On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:  
> >>> This patch-set includes some bugfixes and code optimizations
> >>> for the HNS3 ethernet controller driver.  
> >>
> >> The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
> >> should be a separate series targeting the net tree :(  
> > 
> > Agreed, there are legitimate bug fixes.
> > 
> > I have to say that I see this happening a lot, hns3 bug fixes targetting
> > net-next in a larger series of cleanups and other kinds of changes.
> > 
> > Please handle this delegation properly.  Send bug fixes as a series targetting
> > 'net', and send everything else targetting 'net-next'.
> >   
> 
> Hi, David & Jakub.
> 
> BTW, patch01 is a cleanup which is needed by patch02,
> if patch01 targetting 'net-next', patch02 targetting 'net',
> there will be a gap again. How should I deal with this case?

You'll need to reorder the cleanup so that the fixes apply to the
unmodified net tree.

Then preferably wait for the net tree to be merged back to net-next
before posting the cleanup that'd conflict.  If the conflict is not 
too hard to resolve you can just post the net-next patches and give
some instructions on how to resolve the merge conflict under the ---
lines in the commit message.
