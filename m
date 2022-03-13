Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E57A4D74F9
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 12:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiCMLZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 07:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiCMLZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 07:25:21 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5495F201B4
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 04:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647170634; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=SyRuZYfyRGnenD7AK1rsma5HL0cTnxFxXQb4z3ZvN8KoQfyZth4lFnRIa3Yt+2+X8K4k0k85RbhgLdik5NpuQ/vhC/onfOzfrPsH2yOZUWm5bIFD8GAalqAaRZQP9KmvJP/0uT4XADnNkhAhGUEiGTRiKcWOQ+uOGHdrWmgWACM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1647170634; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=J0nHepRjVy3zDrcjXxlKKt/ZdUtfAtPtO0ncW9ie5qQ=; 
        b=e2MLOQKQaW0GIXCF9ub3chdOOBqdwxI8GLJElEf5lIYkOudysMI3Bwht6+MHWTmfXvLrS9hFoJLddpJJwqVFvPY1uvoA3mFfgf032OtkhXuoeHD01/n1Uh1/ih/Wp/C+CvSI8TxvF56+11oNfVHQhP5xGLypKZhkvOV6/2/jMOE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647170634;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:To:To:Cc:Cc:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=J0nHepRjVy3zDrcjXxlKKt/ZdUtfAtPtO0ncW9ie5qQ=;
        b=KKf9RoN1ZJPuQ+sscXxsD/fFzdiV9KJAETyeTpbczJLSAumAsBXdVoNby0Ucsxd3
        +z4ZrU5OGT36MFffM9FHuJzVa3eD+PEB/XRVltMxXvjydK2NT9nhAcL+5CWztpRrLM1
        dKpy864aAzohRTKi574bAiGOKLi7ktsRIngl8O/o=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1647170631781981.746102969945; Sun, 13 Mar 2022 04:23:51 -0700 (PDT)
Message-ID: <7c046a25-1f84-5dc6-02ad-63cb70fbe0ec@arinc9.com>
Date:   Sun, 13 Mar 2022 14:23:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Isolating DSA Slave Interfaces on a Bridge with Bridge Offloading
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

The company I work with has got a product with a Mediatek MT7530 switch. 
They want to offer isolation for the switch ports on a bridge. I have 
run a test on a slightly modified 5.17-rc1 kernel. These commands below 
should prevent communication between the two interfaces:

bridge link set dev sw0p4 isolated on

bridge link set dev sw0p3 isolated on

However, computers connected to each of these ports can still 
communicate with each other. Bridge TX forwarding offload is implemented 
on the MT7530 DSA driver.

What I understand is isolation works on the software and because of the 
bridge offloading feature, the frames never reach the CPU where we can 
block it.

Two solutions I can think of:

- Disable bridge offloading when isolation is enabled on a DSA slave 
interface. Not the best solution but seems easy to implement.

- When isolation is enabled on a DSA slave interface, do not mirror the 
related FDB entries to the switch hardware so we can keep the bridge 
offloading feature for other ports.

I suppose this could only be achieved on switch specific DSA drivers so 
the implementation would differ by each driver.

Cheers.
Arınç
