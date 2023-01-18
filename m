Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769966711ED
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjARD20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjARD2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:28:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3607811E81;
        Tue, 17 Jan 2023 19:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46B761607;
        Wed, 18 Jan 2023 03:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4FEC433EF;
        Wed, 18 Jan 2023 03:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674012503;
        bh=k96Ml/PDOJtVE05PoJWLCs7yRQ9tZ9Qg1uwWiBkA0tQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ul6g4/P+OIiwUyH+c9MRWQdy+zm850GjjS+F4NVZ0yj3nQ8z2NJZGRldwuZt1KP9x
         jLqoP+2boN7D5ryk+w7OctOKCWqIGc45j9bs91CI8P+RKVxyc8GDQdgDoyS+1jzwxV
         VVYmADt9CyqxIaO6EsoD5SVWCWxb81NOLSFFmOSEEXt+8ui0tta+I2q3SOXCUIn6Fl
         M23UFXz9b4RRrwWLc9Ur1MGQcxuQkIqMTZgrwfm6uYzRMgUnULIlbzQuD2sIjTypnD
         i3sSp55VgLLEJtBpYSlZ4LmphYh5UvHmsV0TzR3qF1jKYu/USZtULuKwjKP7txnjrd
         L07jsbDErmhGQ==
Date:   Tue, 17 Jan 2023 19:28:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jan Karcher <jaka@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [net-next 8/8] net/smc: De-tangle ism and smc device
 initialization
Message-ID: <20230117192821.6bab7f24@kernel.org>
In-Reply-To: <20230116092712.10176-9-jaka@linux.ibm.com>
References: <20230116092712.10176-1-jaka@linux.ibm.com>
        <20230116092712.10176-9-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 10:27:12 +0100 Jan Karcher wrote:
> From: Stefan Raspl <raspl@linux.ibm.com>
> 
> The struct device for ISM devices was part of struct smcd_dev. Move to
> struct ism_dev, provide a new API call in struct smcd_ops, and convert
> existing SMCD code accordingly.
> Furthermore, remove struct smcd_dev from struct ism_dev.
> This is the final part of a bigger overhaul of the interfaces between SMC
> and ISM.

breaks allmodconfig build for x86
