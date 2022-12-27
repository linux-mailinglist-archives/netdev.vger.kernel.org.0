Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6DC656C63
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 16:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiL0PXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 10:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0PXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 10:23:18 -0500
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50344BC22
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 07:23:17 -0800 (PST)
Message-ID: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1672154593;
        bh=mvigTiqpRhpF/g0rsbacNaJiAfOa9S4zZBbT5n84chg=;
        h=Date:To:From:Subject:From;
        b=CC1pJ+oEGPmjNCcA6hZ/mC5OByFiaflDHpN8jy0X19QKi/zRFvvklPkgJayZZvnfx
         kTOaBjEB5vBN+jwQHdPD/IByIE0+Hwp5V0VEBYiMEV4AVUil4h4UjpDG6JvOXwACvx
         efLAg6pj4zhAjPIJmzHOc/nQ2c1it8LQGQSn68yLB1BHYJo3+svmp61IY8OwpwMb8e
         km9/VoA6TvLnh8u1RTMR9KD3DJL+m99c/pxbX8wu74wOZp2I+PTvlIv5Mb1HEIgdQ5
         0S87azj19lU+LwYadg7cujj1Gx9sJpwNjAlZkji5m+OGNIDVzIvDxe1qaPFIMLcsW1
         EMV6hUtLXlWMQ==
Date:   Tue, 27 Dec 2022 16:23:12 +0100
MIME-Version: 1.0
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Nick <vincent@systemli.org>
Subject: ethtool: introducing "-D_POSIX_C_SOURCE=200809L" breaks compilation
 with OpenWrt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1fa60003a8b8 ("misc: header includes cleanup") [0] introduces 
"-D_POSIX_C_SOURCE=200809L".
However, this breaks compilation with OpenWrt resulting in following error:

> marvell.c: In function 'dump_queue':
> marvell.c:34:17: error: unknown type name 'u_int32_t'
>    34 |                 u_int32_t               ctl;
>       |                 ^~~~~~~~~
Not sure, why the code uses u_int32_t.

Bests
Nick

[0] - 
https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=1fa60003a8b8fa25d783867967860656f593822e

