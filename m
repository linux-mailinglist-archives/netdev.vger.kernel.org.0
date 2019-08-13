Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389038C47D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfHMWvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:51:46 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:46659 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfHMWvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:51:46 -0400
Received: by mail-qt1-f179.google.com with SMTP id j15so14563978qtl.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 15:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=12YO/IIEcpAzutOQ77OcFuOv7Ia59JBzwqtjaG8Tw3o=;
        b=m9G9iXxG0tra8ZLrDZkAUNDoOXXnU8o4qJYrlXflxEBt/l6u4m+NDD50sU3egyXRQp
         OPuMAqvU+2tOQKr6LJTn876nvI8giGpX43hYJJdTWG51FaO8K/tlecW2YhN4tj3yweOE
         gYfuAl4wef+B4mwczKnVETDdblrJ9qhL2/0BaO9TbsuM1lbSaZCbQmuoZXZO04rOeQJi
         QC6+bJFs/GwNQzYC9VP4uvlB3kHR6mgeloKG08pVNeVYydT/8sWzPjChHn2uaZ07czJV
         mRv0GJiat9OQKkcbBQOBOG2B4yt61fF20+kcIpf69n6AxgB6EMRnCcsYXFIbKMJDqjDu
         RXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=12YO/IIEcpAzutOQ77OcFuOv7Ia59JBzwqtjaG8Tw3o=;
        b=Mgsa+kGl3fmc/m8v/mG/hI3nKavKp0nVEguB+Fx7JGnnvlFbpYbIhDQBn73C+S7m49
         HriYqu/TwceVf4IdUnuOOOCoq7nGRyMTn1TEn2VeTQZKo/6f93Ha3u1Fx5hHUAcnyhj8
         BJDYO+irLl3XsQCH/B3f2sGNe6fbaUcD+eBHUcOxXa4k53pF9rnHkp2eeewss8pTUTlx
         O0yXy1NY1NTsaPmx9PdqSSmrNoT5e5dTQ8FWV1tJsldta6XQLHntIGxvDsyW5+Oc55qj
         qIS7vLbjLDx7kbMkofEi5x7l+LH1kC6iJOTFgLLIPLk0PjzIVG5lVg5JQbbnpKgK29qG
         HZtw==
X-Gm-Message-State: APjAAAW1d3RBa9MwXvQ09dGhB6CTIuvmvefFq/+s+p3LQfwh6rODlG+W
        aVKP37wlj8lN6f1dqEJzV2XvJWRODFI=
X-Google-Smtp-Source: APXvYqxh+dKrRFjI3KKFwn9z0xRwldKFBX1iwQxmah1K11iKmCxqG94Rg3R5+EdOuzJAVysEbdY96A==
X-Received: by 2002:ac8:21bd:: with SMTP id 58mr10970533qty.192.1565736705550;
        Tue, 13 Aug 2019 15:51:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 15sm8795415qka.129.2019.08.13.15.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 15:51:45 -0700 (PDT)
Date:   Tue, 13 Aug 2019 15:51:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: send notifications for deleted
 snapshots on region destroy
Message-ID: <20190813155136.252ea3a0@cakuba.netronome.com>
In-Reply-To: <20190812122831.1833-1-jiri@resnulli.us>
References: <20190812122831.1833-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 14:28:31 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently the notifications for deleted snapshots are sent only in case
> user deletes a snapshot manually. Send the notifications in case region
> is destroyed too.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks!
