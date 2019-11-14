Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9AFBE3B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 04:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKNDOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 22:14:07 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38862 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKNDOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 22:14:07 -0500
Received: by mail-pg1-f196.google.com with SMTP id 15so2734907pgh.5
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 19:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=w9sOCwYkzAnR1KkNJZulTsz+A/5tDiNQ8JvTgciXuUk=;
        b=WVpKviAvkiCsN6YQR1sgYJs5qJ8RhdFZ2U6hctDwYb83sB8SMJu2lj8TNDJoRFSEeL
         KnRvAL02cdkgsIjq8LpCgjU6/+qOZJM08+rE+UljmryvMFG3OeP0Nfq2ZnX8hNd1ws7j
         sOjRqC3LBPG311tb1vWjXV2iHxD93Km4+jHutIYydAypMzlFuglG4YILaLFMhUDYJ05W
         16nn9yCSG+aAzHKUeCS4V43isj++cu0UNSKwZdXK0q0oc9coQm3VwGgnhI7Hb8qn3Dlj
         f442/gcfSvXQfMmk1Dm7DEYTCwqBeW4GyCzX2alRr2AdjaKMorA22yIvlCCv7Wq4CGeL
         icyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w9sOCwYkzAnR1KkNJZulTsz+A/5tDiNQ8JvTgciXuUk=;
        b=mufdEJljHQHR+Vnq9Hr/shhVuflGba0ZjBFG36SQbiznFVX8lckMr0jjWP8lh+Uvxf
         vJB0Q1jWX+Q+NefoXdFWMGVVnznCgvZ1WZQaHh1kavTZcq861MWZCoZX3O2UV0p8Z6FP
         gTv5qSoq1pwnBq/Q9xr9lgGLExxVxlQJ3YimNaOX35zwxeyWk0K7OYLVm6rwHIBjSfjF
         AIp+Os4ckV7ELhzkxBZZqtqzHm5LiFhJPu51L3lf3UOcxPRGMNnopuSvTMqcPVh/IE7G
         t9m0TTVTyqXpzA2Y0hnNPgkdOWfe9hA6siZOvVC3smiYp4kCkWnb3ckpjZ6u+G3nsIWY
         uI1A==
X-Gm-Message-State: APjAAAVR9q2tCsqeivKqjl2bwJqnacMKubhsh00KgRBB+oF0vohKPILW
        Ve29NrlGCGAE5/qrQ1gnVRP6rw==
X-Google-Smtp-Source: APXvYqy24kEEc9S3Ul9P3rPe9CykbSAg/5wXYObTKjZkRN2LcVOqNxt6BVN4VGPY8s6pffE2+/Wc3w==
X-Received: by 2002:a63:2f47:: with SMTP id v68mr531632pgv.239.1573701246298;
        Wed, 13 Nov 2019 19:14:06 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g3sm4157788pfo.82.2019.11.13.19.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 19:14:06 -0800 (PST)
Date:   Wed, 13 Nov 2019 19:14:02 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191113191402.27dbba26@cakuba>
In-Reply-To: <faa43582f7a038fb835051e0473866b325a5a6e1.1573656040.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573656040.git.rahul.lakkireddy@chelsio.com>
        <faa43582f7a038fb835051e0473866b325a5a6e1.1573656040.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 20:09:20 +0530, Rahul Lakkireddy wrote:
> Add TC-MATCHALL classifier offload with TC-POLICE action applied for all
> outgoing traffic on the underlying interface. Split flow block offload
> to support both egress and ingress classification.
> 
> For example, to rate limit all outgoing traffic to 1 Gbps:
> 
> $ tc qdisc add dev enp2s0f4 clsact
> $ tc filter add dev enp2s0f4 egress matchall skip_sw \
> 	action police rate 1Gbit burst 8Kbit
> 
> Note that skip_sw is important. Otherwise, both stack and hardware
> will end up doing policing. 

You also can't offload policers from shared blocks (well, shared
actions in general, but let's say checking shared blocks is enough).

> Only 1 egress matchall rule can be active
> at a time on the underlying interface.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
