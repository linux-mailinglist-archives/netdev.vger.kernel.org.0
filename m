Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD68B9AFA
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407255AbfITXzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:55:12 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42415 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404881AbfITXzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:55:12 -0400
Received: by mail-qk1-f194.google.com with SMTP id f16so9054818qkl.9
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 16:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hvbwLMt0ZWL7UOJYW/rYLQsePGOhdz4ENEPZKX2Atts=;
        b=vHoDkbutpaWxjOb4EqzvGeoHX6SU2sWD98OnDo/mIkSX8kyHDpm6pE/uAVG9jdxKXm
         g3VhutC2nJOZEKY0dR+UBG7D7w6zP2oKWfsqU3yz032VwRCD/nLC9HPvthDXFZ9CLd0f
         oS+5aqvPuswlA2sQ+o5zwKKrEEBjcH4ZdZzb6BbKo8UiPn3eNasXNkeCaIVgka5WigpN
         pK24TteIpwZ+CrNOkKt7QByNzyzM3pAI3newmjdFbxsTke2x0Fm47/arxQ4W3lK6HXF0
         Z/vwkTZL8cBM3f6zmQDHRMHXrxVqEWwpnMQ6nP0ygYBbPM/nLkASojJf4o5fPrDf4bD6
         lVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hvbwLMt0ZWL7UOJYW/rYLQsePGOhdz4ENEPZKX2Atts=;
        b=OTlJYWIlg794OyYValrtSBVUGRZUXEtICgnuFo8IeQTHBeAuqO+CKExGlv0CKh/WBw
         P/VRvG/UvsJU/Ca3GCSesgOgQpcQZ5VjczrySCCT4DctAeyXfA4G2kunJUIvKKuK5XiE
         0ydUD6o9ZPfbGNCnkhhGdi4ClwF4qdxfYB9piveU293m5WZmbYtGjsIzC+O+bjpzQe5M
         uIuznAK8lBeTrPDGRQajRNPZxCkcqn+jC3y3pwFWeggFobBrv4Boryci1UR6tmtBRnG9
         rj46oZYbnpu4Hzo5mTQcedYzS2MnczTuKStfOmJNqwpdxSu8RuOFiQHpfmJQIImp3c9j
         h2xw==
X-Gm-Message-State: APjAAAWW3xpYvRYqoxSLjTRGnOlH2yVXolnrQ8jAJSqYhxJOqo3xKJlP
        g0DDqz2/JQ1gVsjAvU+tJNr4Xg==
X-Google-Smtp-Source: APXvYqzIse47eDiQDynO+1LV0Gn/SrLFRyVhdw54ID8Kdgsrby+lZfzAI84sqscmZaisN2PX/5/3AA==
X-Received: by 2002:a05:620a:12b5:: with SMTP id x21mr6422269qki.462.1569023709425;
        Fri, 20 Sep 2019 16:55:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d45sm1735572qtc.70.2019.09.20.16.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 16:55:09 -0700 (PDT)
Date:   Fri, 20 Sep 2019 16:55:04 -0700
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
Message-ID: <20190920165504.2ed552ac@cakuba.netronome.com>
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

Could this perhaps be achieved by creating prepare, commit, and abort
helpers? That would make the API look slightly more canonical.

netdev_adjacent_change_prepare(old, new, dev)
netdev_adjacent_change_commit(old, new, dev)
netdev_adjacent_change_abort(old, new, dev)

The current naming makes the operation a little harder to follow if one
is just reading the vxlan code.

Please let me know if I didn't read the code closely enough to
understand why that's not fitting here.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5bb5756129af..4506810c301b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4319,6 +4319,10 @@ int netdev_master_upper_dev_link(struct net_device *dev,
>  				 struct netlink_ext_ack *extack);
>  void netdev_upper_dev_unlink(struct net_device *dev,
>  			     struct net_device *upper_dev);
> +void netdev_adjacent_dev_disable(struct net_device *upper_dev,
> +				 struct net_device *lower_dev);
> +void netdev_adjacent_dev_enable(struct net_device *upper_dev,
> +				struct net_device *lower_dev);
>  void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
>  void *netdev_lower_dev_get_private(struct net_device *dev,
>  				   struct net_device *lower_dev);
