Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035DDB9AA5
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392750AbfITXYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:24:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39169 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390685AbfITXYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:24:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so10592749qtb.6
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 16:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pOKCC3TcJzw93oLf3uzhuR7n20ss1OnKDoImIgRNF4E=;
        b=yFl3zkKHOsTcfiPc6bI4RkZjmpjeJ3AmrHqaGZH//j7CLb4IbWk5iaWt9fBvq+Z3aR
         F9ArLDdDK9ki3gT23IxxbAou6wMgCde8Sf4uZukrURGCqbojJKeB5joalKZIvd8lWOiD
         yTJLAXbbMxYz0z8JTB8o61TXUvikzy8rdvPqbX43HLk+Qt+wHS4jVtjNbri6R83HsW4P
         rIhK0EtCDqGowpj0V9rBBzI4prfoz9i3qSEXxs4iULsUw6KnecvKUTK6/PBgoVMFwpWq
         JaLGBva0fAx6suYTYimxnkBN9aL+avPE2YttG1a6SOTaOYPB3hxFwxt6iD38IAxAlfc+
         zrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pOKCC3TcJzw93oLf3uzhuR7n20ss1OnKDoImIgRNF4E=;
        b=UBGKaS3AQ7daUNANc1/JehDhJ1aSzp1+bt/5AQjQTX03/lVRr939XHel8t6T47w4Qw
         ifgjzQPCrrZeYsHasCAjItfDnlvplYjIHZ3bFRyqFOikH9BML+F2mHPyKLDH7w4SupMh
         jINjlm77rH/yfX04JzTAikmc0BDBWItykUN49NSLpxzfZVKzXt4ThAU/ioeu6TST2dHA
         MXUnuKeFY7yZ645tEPWzS6CFrg2D3fVWpSBoPm7ncoHuZcgARgSdKTJhWUqSRXJuaQNv
         oCuDWOJ5osK06sX+6Xi05WT84nXci/GlkMJpOp4vX+Rql/b8hQyAXAvu9ahJRFezgWOQ
         kkuQ==
X-Gm-Message-State: APjAAAUOM/Xp2sRxqlqPhTDWwQmZMGoJqe2eP6bEEBdD7UDHlqUXGxCN
        UW/6qkYeSXpapsd786GjYLiQMQ==
X-Google-Smtp-Source: APXvYqwIRuY72pS4+uygdMbPXpA8Tw8RQ+b03b/GmERL4Z9/QoIIh6YGMwVd6Uh2QncA02EQZj/+Vw==
X-Received: by 2002:ac8:47c3:: with SMTP id d3mr6320332qtr.4.1569021890100;
        Fri, 20 Sep 2019 16:24:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d127sm1822187qke.54.2019.09.20.16.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 16:24:49 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:24:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Subject: Re: [PATCH net v3 09/11] net: core: add ignore flag to
 netdev_adjacent structure
Message-ID: <20190920162445.5eebca98@cakuba.netronome.com>
In-Reply-To: <20190916134802.8252-10-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
        <20190916134802.8252-10-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 22:48:00 +0900, Taehee Yoo wrote:
> In order to link an adjacent node, netdev_upper_dev_link() is used
> and in order to unlink an adjacent node, netdev_upper_dev_unlink() is used.
> unlink operation does not fail, but link operation can fail.
> 
> In order to exchange adjacent nodes, we should unlink an old adjacent
> node first. then, link a new adjacent node.
> If link operation is failed, we should link an old adjacent node again.
> But this link operation can fail too.
> It eventually breaks the adjacent link relationship.
> 
> This patch adds an ignore flag into the netdev_adjacent structure.
> If this flag is set, netdev_upper_dev_link() ignores an old adjacent
> node for a moment.
> So we can skip unlink operation before link operation.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

I think there's a number of local functions here which are missing the
static keyword, we'll get a flurry of fixes as soon as we apply this.

Could you please take a look at fixing that, I think W=1 should help,
-Wmissing-prototypes in particular, if I'm remembering right.
