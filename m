Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390B89D590
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 20:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387749AbfHZSN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 14:13:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36887 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731907AbfHZSN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 14:13:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id d16so423002wme.2
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mP4LZyO2QAO+0JCH/Fjfva0s/ewFbinu+IOQwqJx8nE=;
        b=wG99Z2f55De8c4CGaqvvgaMixyVXoMZbcILOLWjKKIonoMqWTe5kYc1jKpX5iXLnvh
         xzwLbtoM3Lnbb/qPhdkeYhI4ByqGRcGwklIZBcXqsh0kzug7F2+4OUqEgRVX/OfgPQKo
         DuLSW3vxtl5AZx6py1tHA6/s9/y5CpsNQadcZkVJ5RoFlYSMxUySI+jJgefgCUduImU0
         W5TM2FLiwCDhJ0clp8u5KCdJJBpeGYddJ6nYr25AGSdwJUWHTDbdfQGmT4Yvgujn+dIt
         xnuzYC+NPNjlW+r4LhhUkhjQL52k2FFGr8qxVqA5tpcWfqRJO+5HfG8pR2EULH2RqOto
         bJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mP4LZyO2QAO+0JCH/Fjfva0s/ewFbinu+IOQwqJx8nE=;
        b=LWicpaXccFrkcNzPbVwkCy50BmVwOyq4WH7BK2QE1Y+Nntkk3giPUzoDPHhgIfhgem
         tj9+3XtbOYg3Ecd0cxMytBpCVHqZNqCIM3Vn7/v7N2Sr5aLQeXQ452bkxv5W+h0mxfLE
         EPdVFqnUXKNDss3AhJkPuyeI9dVnfQXqCPQqGjKTynNhco43HHQ2u8s1IbCT9syJvoVJ
         3+GnGCzarPyIl7sGmha+P78JMohxxiC1FuF7L/v0aEPSex6471pZTEUoPR14Abr+tcND
         /9RlsHCyP1GuHBb0Wi0zNzPWhEYwAprsPGjiiPRN1z55czAlkMmFZwgieuPaJhWOawYF
         J9/A==
X-Gm-Message-State: APjAAAUt187bZae89D0bDOVnKIAOaSCOaK750nQ7IE9W8zGppRHmudRL
        OFMyFxK91/fPYL0CE6DbMyobA16MTRM=
X-Google-Smtp-Source: APXvYqx9JRh/nZiD9EZunv8SQl+wWqHRDb4jctcl0Lch2wKfFqDczaTBxD6pPFhikxUOPIcqpi7Z3g==
X-Received: by 2002:a05:600c:34d:: with SMTP id u13mr23878086wmd.48.1566843205976;
        Mon, 26 Aug 2019 11:13:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q24sm723196wmc.3.2019.08.26.11.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 11:13:25 -0700 (PDT)
Date:   Mon, 26 Aug 2019 20:13:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 06/10] net: sched: conditionally obtain rtnl
 lock in cls hw offloads API
Message-ID: <20190826181324.GG2309@nanopsycho.orion>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-7-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826134506.9705-7-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 26, 2019 at 03:45:02PM CEST, vladbu@mellanox.com wrote:
>In order to remove dependency on rtnl lock from offloads code of
>classifiers, take rtnl lock conditionally before executing driver
>callbacks. Only obtain rtnl lock if block is bound to devices that require
>it.
>
>Block bind/unbind code is rtnl-locked and obtains block->cb_lock while
>holding rtnl lock. Obtain locks in same order in tc_setup_cb_*() functions
>to prevent deadlock.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
