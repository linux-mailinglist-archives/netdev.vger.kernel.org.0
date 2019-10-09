Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9AD04FF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfJIBFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:05:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37271 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbfJIBFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:05:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id l51so754704qtc.4
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 18:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=q1+GPiVXlnkIGxz842Wha8YrodBxjB64of3Q3DgqLsc=;
        b=owaukz8IOr9xL0mkMCb7bObdbl+AURYpH0pTaz0koZYb8t5yRZMiLrbLyE0Azsggze
         EmUAlEWVEzw5nrpbK9uEx16Fi75TT6EnfPdRuF0ioASsUuVFVgbvl/viSlzUixWHzU+v
         4dtYnasZrmC0vRf93u5douEdUwpCIAzDFOyBrv/WdAYI9Ogw+rjrtE58svaDRZArU8vW
         +0Idbqur2VoCESe49ZNnSuNtZ4rj4k4IWVe3Wxszv9zRmPp3kU3BBG5nbiekGFqBJhwf
         Ng/AMHv3d5NdrB0J29qiTT+epTCJq9IgaVyLjhhucJ0WXZCsYBgOipbG11W9tAPSLcXT
         r6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=q1+GPiVXlnkIGxz842Wha8YrodBxjB64of3Q3DgqLsc=;
        b=G+zmsWEjJNum3A3ql0sT9PT1WKRftbXdoxD0pqzM4HAhsO3ivPenHLGyAuIv0WXkRO
         e8P+t1ToSEGzRozL3Xuu7yWwT1ZJRsrvTZPSQH5WvtOWJyW7v1GAXKqpmM9cq65HNFIF
         ji6ZusIGQtVEyPldq+iLSFcYPkBaZ1Th0HrEYoC3/nyMSFa85xbuzcgmlezFEKOS5hPi
         Ax+aFHl4JAZMiht/cvX8ExhtneK/3F8lVBXWtQ2r+cs3K4F6cLp02lhGUzWRQtfUA7P6
         b3bjXLPwThSuN7INl1lhJi3zyb7QGWfnf9Q+BTk/01e6Mh+8hTqUWPq5PB6BnNQUvEEC
         cY6g==
X-Gm-Message-State: APjAAAUz+ssl9pSDSDL3UH8MtFsSh4BRJdh+rX+Epkl/IPnbhXml5+3p
        7tAdEtM7fRC9TcrD43SV6kxhqg==
X-Google-Smtp-Source: APXvYqwO4e8DcfvCwiQryXHFiXnlYE5Idxzgzite9cjCqLNXPpgP5+1WGnh0B4BMrIMFTzzHlKuxHw==
X-Received: by 2002:aed:37c9:: with SMTP id j67mr930434qtb.291.1570583149991;
        Tue, 08 Oct 2019 18:05:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u27sm342305qta.90.2019.10.08.18.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 18:05:49 -0700 (PDT)
Date:   Tue, 8 Oct 2019 18:05:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, johannes.berg@intel.com, mkubecek@suse.cz,
        yuehaibing@huawei.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: genetlink: always allocate separate attrs
 for dumpit ops,
Message-ID: <20191008180536.2bf358a7@cakuba.netronome.com>
In-Reply-To: <20191008103143.29200-1-jiri@resnulli.us>
References: <20191008103143.29200-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 12:31:43 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Individual dumpit ops (start, dumpit, done) are locked by genl_lock
> for if !family->parallel_ops. However, multiple
> genl_family_rcv_msg_dumpit() calls may in in flight in parallel.
> Each has a separate struct genl_dumpit_info allocated
> but they share the same family->attrbuf. Fix this by allocating separate
> memory for attrs for dumpit ops, for non-parallel_ops (for parallel_ops
> it is done already).
> 
> Reported-by: syzbot+495688b736534bb6c6ad@syzkaller.appspotmail.com
> Reported-by: syzbot+ff59dc711f2cff879a05@syzkaller.appspotmail.com
> Reported-by: syzbot+dbe02e13bcce52bcf182@syzkaller.appspotmail.com
> Reported-by: syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com
> Fixes: bf813b0afeae ("net: genetlink: parse attrs and store in contect info struct during dumpit")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Dropped the comma at the end of the subject and s/for if/if/, 
and applied :) Thanks!
