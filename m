Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02E08C4F2
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHNABj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:01:39 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38354 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfHNABj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:01:39 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so10287685qts.5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 17:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xssC0a/ziZNldi/K6olAWtxmbOH5XhktsDP7f6i4uq0=;
        b=H+DMckucDg7BIvaULwRB2/9CqTzLJL7iFfuJmXzXv24vrbP39h4Tm4wfpRdteGh6Gi
         7+cuW7woWFtlP73kuYpZE6zYHU8RFSvFScZYmQBucX36PwpdAoGUdtTbKqfKczOlrZ+E
         nCOuMauzVqCaVBK62b1edlnmhO5ECGY5LKr2Tfm5g/UofFkkmoMSkSdYgMF/uBJrI/O3
         wKMpVtndKr1eK7dX3+yOa3fGLg3VmMUJu53/5aJj9ORS4tB00GcLWGs2n2QqzsxjgEXb
         LcQ9xFUtNtPY0RN4wEW4qFCZn1OLABMa7+8saocsAJqzLsuDg5QYWdJs78ZCbnctld1o
         YLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xssC0a/ziZNldi/K6olAWtxmbOH5XhktsDP7f6i4uq0=;
        b=DpQXzziVrOFEOGwjJ7r31GHE2UkNc6ESnQnwhTUU0W2n8a1LqK2GWPQfFU4Me5rs+Z
         KaALZNrkhQhTio5Y8c9HO+UnMXPQXfoII66Mfm0bFqZVUA5ymBhiB/zc0HkvkeC4Lmwq
         wOnM3+LKcuPKSd6PQVFVnU+vVIkxiDIoW6oZSN0/02rk6TlX5Ba10UYGsMlBO1f3FbHq
         zXAo+Pox0adZz85OUVTSVlBP4c7diPveQT1LUTOxhY5TA9YFnhVCKcLQiFZ979vNHIfO
         bK8xBg696lSpzVWqLO7gTANlSMTHa8I67B8re307pN0QSZv5Yph8H57nMS48gOxDGAnf
         Q86w==
X-Gm-Message-State: APjAAAVAyr5XrKnF1PXY7bfVPpt596QEmcNc1BfeP/q0sbg8Dzj+OE8G
        YqoE4sF3BdaY6TiAlLFhCbqk0g==
X-Google-Smtp-Source: APXvYqxeALLgCJdQLlfOKGOyOJdKgcdq51vN+OVLigV5Gf29a4/Kk++JP4SknJJS9EsBha6kwLKrVQ==
X-Received: by 2002:ac8:96c:: with SMTP id z41mr24648383qth.319.1565740898467;
        Tue, 13 Aug 2019 17:01:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r19sm5441307qtm.44.2019.08.13.17.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 17:01:38 -0700 (PDT)
Date:   Tue, 13 Aug 2019 17:01:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next] net: devlink: remove redundant rtnl lock
 assert
Message-ID: <20190813170127.352b0473@cakuba.netronome.com>
In-Reply-To: <20190812170202.32314-1-vladbu@mellanox.com>
References: <20190812170202.32314-1-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 20:02:02 +0300, Vlad Buslov wrote:
> It is enough for caller of devlink_compat_switch_id_get() to hold the net
> device to guarantee that devlink port is not destroyed concurrently. Remove
> rtnl lock assertion and modify comment to warn user that they must hold
> either rtnl lock or reference to net device. This is necessary to
> accommodate future implementation of rtnl-unlocked TC offloads driver
> callbacks.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Looks good, applied.
