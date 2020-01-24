Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBFE148B3D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbgAXP2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:28:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53940 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgAXP2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:28:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id m24so2021503wmc.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cMN+h/PmuzxgpG9+gbRvVq3p9XeAcZcthLwD/uayB5Q=;
        b=swO+ccUT1LNohPnj+27nmy5lJ6EiMMHfz8uR/0a9qHRAV5J9kamvPHXy24F8/18inm
         OQG+BK1y7BNFy5tYEf/8emt0m/dlht0Vc/0EhjKrrRHOnKfqLYdHei2DcYtTY//B6/XG
         8HBB7fyHCF+lklw4WMyDO/EWW04L03goULPVXLWRMthKOHMPeaGjxx72HA1hlCrosFsd
         5D+5GEcMWlvsE3YOZrCWY9WRQH4J1ooN2CMEEhyJ2wUGZKAqK1MT9OmJJiU1Tp6zCYxK
         MWop6ovRg7LUUk704T/1dblMoSnaNsyzdaVw4Qp4Qm6jDhXH0y05xZsJXFEeLSDst+0O
         fv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cMN+h/PmuzxgpG9+gbRvVq3p9XeAcZcthLwD/uayB5Q=;
        b=M+SoAy3EDhj7O8/e/Cq3DXdlSkzb3sElQgaMAjL2Ffk306pNkV8XxNAxWk6vE8DuHf
         LeHDvj18mIWI2Qw5zgy2u83Bc3OzYVZxTTj312nCBFJOTczRKsjpl+cKiWHlS2PehlRo
         lworCLifnVvCo0TIP3iaLxGSScCu1OHRHpattriBexc+rQoJ+pTqFjguE/AJGOKglNKu
         tXpRQPF+8wigs9eSx4UYSMPlVDE2WBrNTBPW17dzobf8fkP5nQi4+QHCgq63QDX64Kc4
         vN95lMHGtgwXycq9JMtiWih8IuNKZ/hvroUfB2TGSaoF8MJWGty6EOZGfEaM7oI/xtg8
         JyHg==
X-Gm-Message-State: APjAAAX9Hxh00sh9FiRK3qjRpaoonbwX4bhPTwK2yoEkKzjTq+tA5Fuj
        VdBJRBfTK1IOYaPInnibtjRFKA==
X-Google-Smtp-Source: APXvYqwVsvAMN19HeWQFbJqC3wHz01QVn47NMJ73uasHliOmgIy3Kst6cPB8DBhpHU5HdsCvH+Dfzg==
X-Received: by 2002:a1c:f001:: with SMTP id a1mr3653754wmb.76.1579879679485;
        Fri, 24 Jan 2020 07:27:59 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e12sm7774541wrn.56.2020.01.24.07.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:27:59 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:27:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 10/14] mlxsw: spectrum_qdisc: Support offloading
 of TBF Qdisc
Message-ID: <20200124152758.GH2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-11-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-11-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:14PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>React to the TC messages that were introduced in a preceding patch and
>configure egress maximum shaper as appropriate. TBF can be used as a root
>qdisc or under one of PRIO or strict ETS bands.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
