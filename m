Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D955018FFC8
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgCWUsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:48:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32722 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727060AbgCWUsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584996533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=19Pb1MhvkDiHk8n1emF9MeRRzeLG0aOeNqRiqUhy+Rw=;
        b=WItKSfRawKLxELwdvQ7j5Lq9bbgKHobi3TaN6gYCo6oyMedthLr3jdtqG7RrMnkCaG/hNG
        jX4z6gqPKGIF3RbK92pJhP6SU+Yy/vxAxIbP7T14vO5YjW5MvATtMmx5daUXjwXQ/9RFUl
        XsrWCp74935o3zy/QTo9gvRhcGxCr2U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-zEz5FkkbPQ21aoMYA4trzg-1; Mon, 23 Mar 2020 16:48:51 -0400
X-MC-Unique: zEz5FkkbPQ21aoMYA4trzg-1
Received: by mail-wm1-f69.google.com with SMTP id w9so424394wmi.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 13:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=19Pb1MhvkDiHk8n1emF9MeRRzeLG0aOeNqRiqUhy+Rw=;
        b=pqKMErZWcEEcNsuxyBBTuWmDx3WInz+rLwwpixukLabRJSZgt7QBdxY3k94O4Z2Mr+
         +C+p2dhT+ZichCa+OWTtwQuNhH1SkPsJVQSAPqivqZuARutybGxh7V4miPtbadcNgFJc
         lrwEEeBtRTBx3UFokYJg3DXb3Czw6AJAEF1unrHoVviNu+D0V783eSrKBW/bs4dNX92W
         JZl1FKdKOkjY8hY7GF5Qlh3M8reDBHvNp2ibwfXJ+tLQpJrSl88UzxqxFxS5aGXqNQIt
         GJcqLp3ayx5O8bvGqhSEzXN1h5bZx+xAyk9xSL5PJ5NP6lQoum8aLMMqVflTWO5kvz55
         Khwg==
X-Gm-Message-State: ANhLgQ2eusmzcOmN1XL8mmaXr+oN6NcmP9p/xKvGP7q3C6n2Di+JSN9P
        RL+YLh7Xpg/WTb4ZckGOl5U7XB/Wx7YFVMjB0RRw+wqrYpldXBKBg22NpLbQOYqFfT0Oj/OKrav
        tObLBTBoY3EMs98rn
X-Received: by 2002:adf:b650:: with SMTP id i16mr31745095wre.316.1584996528726;
        Mon, 23 Mar 2020 13:48:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtaNNvYB8xSsMqfxUsIh/mm/b8Wy1ZijXTaYwJy4HKroU7RPhi5HszTe8LcFNXoSN2qNi4UZg==
X-Received: by 2002:adf:b650:: with SMTP id i16mr31745072wre.316.1584996528426;
        Mon, 23 Mar 2020 13:48:48 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 61sm27445850wrn.82.2020.03.23.13.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:48:47 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:48:45 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 0/4] cls_flower: Use extack in fl_set_key()
Message-ID: <cover.1584995986.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing extack messages in fl_set_key(), so that users can get more
meaningfull error messages when netlink attributes are rejected.

Patch 1 also extends extack in tcf_change_indev() (in pkt_cls.h) since
this function is used by fl_set_key().

Guillaume Nault (4):
  net: sched: refine extack messages in tcf_change_indev
  cls_flower: Add extack support for mpls options
  cls_flower: Add extack support for src and dst port range options
  cls_flower: Add extack support for flags key

 include/net/pkt_cls.h  |  8 ++++--
 net/sched/cls_flower.c | 60 ++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 19 deletions(-)

-- 
2.21.1

