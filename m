Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8A2031E
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 12:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEPKHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 06:07:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39042 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEPKHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 06:07:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id w22so1329810pgi.6
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 03:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GTOUHeX898Ys2mgen1fzWMfTs1Y6uPYVHbFZQav4/vU=;
        b=Nxjjg52BU76T8mqijHGimsbayBzlpgeYk3LZlOyYebF4WCMwWAp/P3ald2Q2EB+LWU
         W1GmfiP85pByXT6n70t9vBLvbkxMHhhy5k12e/rq9xaRlxp1UV2CicCoZr5U8IcO8gLH
         IGcWXkXoxkmUxVpa72k8/Y6GEWoaA0K5jg6TQSwh41uWxyCA6V10+aUWjUEy5GW6zSGf
         t7Dg4EW1IgTGfzYykovrGjWIkkg5gaIwc9nUGo4QCPIHULtJbfoonLw/HAfdYEhVLvev
         fqvr5fE/IFGYoELo2vgUOLi0POpx2SrfO9Bo22LqPH2tbXL2jXL0+vdLlS7k7K5MgdPZ
         MmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GTOUHeX898Ys2mgen1fzWMfTs1Y6uPYVHbFZQav4/vU=;
        b=Almn8VUmNmEPadV5kZ0zLk2kggKe0BnyRDXunzuR8LhaCLp8MTgJmo3PhRw6RPI+DI
         nHAKUNYAbP8IUUbSIQY+vkx+Dv0yIy5Lt2H6+tKEnOM6mOn2jaU5y/wqv2IzIaak7pQy
         eQG/7NwDQzTdb6SR2/E/EmIx1k/yLPcggK03B/dCK6glWS3v/mXLQGgL/VITISUzgTCz
         uO8ZVH2C5sjbo8tg5cgJJgKJP+b7l2m7i0MWMpzSJFSPMInpEXF6QvzwggXzWOhnm4dv
         jdTkRA9zUKbb8wtZlNnyoytbjKJ/PShhgUNlFm0LkSQzRom+/m3DHBnimGBclT0utg/c
         NQaw==
X-Gm-Message-State: APjAAAUZFnBsPutbqkZvDHspSNHDK2Y3K/gnkQjfTtIH3f/mBPW8XUVD
        fOYw8AMGjIWbz9eQtQjE9mtSoz98DQo=
X-Google-Smtp-Source: APXvYqx/yWcYvjuEiRFFqn3s57iqflSwOGQDQTxyofQetlLhYrnDi/Zu08Eei4piOv3vhSWZ6EUoHg==
X-Received: by 2002:a62:cfc4:: with SMTP id b187mr54983019pfg.134.1558001243766;
        Thu, 16 May 2019 03:07:23 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m8sm5184242pgn.59.2019.05.16.03.07.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 03:07:22 -0700 (PDT)
Date:   Thu, 16 May 2019 18:07:13 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Robert Shearman <rshearma@brocade.com>
Cc:     netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ying Xu <yinxu@redhat.com>
Subject: [MPLS] Why can we encapsulate outgoing label with reserved values?
Message-ID: <20190516100713.GT18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert, Eric,

In commit 5a9ab0176198 ("mpls: Prevent use of implicit NULL label as outgoing
label") I saw we disabled setting label 3. Is there a reason that why we did
not disable other reserved values(0-15)?

I saw function mpls_label_ok() checks the index and reject all reserved values.
With this two different handles, we can encap a reserved label, but could not
exchange or decapsulate the reserved labels. e.g.

# ip route add 10.10.10.2/32 encap mpls 3 via inet 10.3.3.1
Error: Implicit NULL Label (3) can not be used in encapsulation.
# ip route add 10.10.10.2/32 encap mpls 0 via inet 10.3.3.1
# ip -f mpls route add 0 via inet 10.3.3.1
Error: Invalid label - must be MPLS_LABEL_FIRST_UNRESERVED or higher.

Thanks
Hangbin
