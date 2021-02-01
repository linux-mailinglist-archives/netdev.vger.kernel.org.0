Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0248D30A004
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhBAB3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhBAB32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 20:29:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696EEC061574
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 17:28:48 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m12so173526pjs.4
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 17:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nile-global.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=I6KF1CSuO3C99kTgXC7oBdCsHctAm7inEQRALW8ydTI=;
        b=Abxl5Ch8R0LQH/wM3WOmNjOr38Q8cZXiacAyeIoRra0M37KTwADy3OBY7mSLu1PT17
         yBscwoFpCVjncC9QfsP4w5SvTjaHHZDEIw1ZJSZgv4xP5+ZdaKUNNXIBvsojWxkJevL/
         HFg1L1iS3I1iyLZ29vsjWYKcK7pOdXmhi46+ZuPYZIZDe/GWuGAMoOEB5bLCs57mIx9V
         m4HwyKnyROIzPcw9DbD507WcT3NiZYO5djreX1Iezvj/u0WiPc+qptEDWrnZgT9p2V5u
         VdBtlw9sahMw84rTUaoaaydsxFEPTEqMAyEnCFK669bE0Dn/qKrou5HW4kzcS7ISZRig
         5JzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=I6KF1CSuO3C99kTgXC7oBdCsHctAm7inEQRALW8ydTI=;
        b=UeArIGb2OPXjJfwGYmybB9xvndzAAMeYW9jF1fGNkkojYpcL/3LL4jTK/TAd32AOyl
         RC65+dCb7XSKQA9X+giypX0gp0U0T1W8c/p/dwHmCHBdAp8qDdqMNf7u9pAHPBGLipI2
         2ntdTphXw0cXU2Z/HLl2KNvq+x6DQF+NFUzd5krW6a7DuKKoLj5gWgN6ykxapkOSP4ol
         IY8Zbx+uTvjW1Fcm7+hWQ2FOjTpUrBVzuHS8K4gKjY6Yef7xntsNqTRRaqcUJ5g9duLR
         Rgonxc6DTCPflQ6SwR7qmEK1PyA2JU0VMnWl9tlk6ChmNLePLa+LsbqZ/14Vvoesvb50
         BwIw==
X-Gm-Message-State: AOAM5313CZt2OT3hRMhjyMJBkptwblWm4Rteh03os+rUwcu2+lQQIYEX
        ZlgFWLWCR7pfmp2Z/xoJDZeI2KXnNey47EfinK3DOugRzu2CSg==
X-Google-Smtp-Source: ABdhPJzrJvkhOnhk3HijG2YhuUvIJ8Y7lluVg3kFQ59LFr5RrN+xBgcNPwpgiaJQVoWQkr+IiWoCKaqq1L8dIOxmvrE=
X-Received: by 2002:a17:902:ed83:b029:de:84d2:9ce8 with SMTP id
 e3-20020a170902ed83b02900de84d29ce8mr15427707plj.17.1612142927485; Sun, 31
 Jan 2021 17:28:47 -0800 (PST)
MIME-Version: 1.0
From:   Gopal Raman <graman@nile-global.com>
Date:   Sun, 31 Jan 2021 17:28:37 -0800
Message-ID: <CAJO3-cR0u_c9rOigq=OEBiJoBUnD=XVfi0Vb+oMnhSF-xpL75g@mail.gmail.com>
Subject: 
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aquantia PHY experts
This is a very specific question about programming the MACSEC
component of the Aquantia PHY (specifically AQR114C). I'm using the C
API ( AQ_API_3_0_4_AQRATE)
provided by Aquantia to read/write the registers over MDIO and have
compiled it into a kernel module. I'm running on a 64-bit ARM CPU from
QCA (IPQ807x). The IPQ807x
has it's own proprietary Ethernet MAC that talks to the Aquantia PHY.
I'm able to write the MACSEC tables from user space (specifically in
MMD 30) and read them back

PHY Hardware Details
Reading Static Configuration register gives these values:
oui=0x300ee3 modelNumber=2 RevisionNumber=2 firmwareMajorRevisionNumber=5
       firmwareMinorRevisionNumber=3, firmwareROM_ID_Numberfrev=193

Current Software Status
1. I'm able to write and read all the MACSEC Egress and Ingress Tables
using the APIs provided by AQ_API. I'm also able to read the stats off
the PHY and to clear the stats on the PHY
List of Egress Registers written and their values that were read back from them
1. EgressCTLF : action=1 ; other fields are all 0
My eth0 MAC is 24:15:10:2F:E0:68 and I've copied this into mac_sa field below
2. EgressClass [Index 0]: sc_idx=0 sc_sa=2 tci_sc=0 tci_87543=0
tci=0x0 action=0 mac_sa=0x2415102FE068 sa_mask=0x3F sci[0]= 0x2F101524
sci[1]= 0x010068E0  valid=0
3. EgressSC [Index 0]: tci=0x28  protect=1 fresh=1 val=1
4. Egress SA [Index 0]: next_pn=0x1 fresh=1 val=1
5. Egress SAKey [Index 0]:
11111111:22222222:33333333:44444444:00000000:00000000:00000000:00000000

One anomaly is that the EgressClass Table entry shows "valid=0" when
read back even though I write a value of 1 to that field
6. set MACSEC Enable bit (bit 1) to register 1E.C47B

Ingress registers are also written but not shown here since my
question is about Egress only

Next I assign an IP address to the interface and initiate a ping. The
packets are going out in the clear. MACSEC protection and encryption
is NOT being applied in the egress direction.

Questions
1. Are the values in these Egress tables correct ? Is the register
address for MACSEC Enable correct ? I got this from AQR405 register
spec since I don't have the spec for AQR114C
2. The API does not expose any other tables for Egress. Are there
other tables that I need to program ?
3. After the ping the values read back from the EgressCommonCounters,
EgressSCCounter and EgressSACounters are all 0
3. Looking at the atlantic Ethernet MAC driver sources in Linux
[net/drivers/ethernet/aquantia/atlantic/aq_macsec.c] I notice in the
function aq_macsec_enable() that the MAC sends a macsec_cfg_request
"message" to the PHY. Is there any such equivalent in the standalone
PHY that is not coupled with the Atlantic ?

Any help to unblock me appreciated. If you can point me to the
register spec for AQR114C I would be very grateful

Thanks
-graman@nile-global.com
