Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F3A5EE1C6
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiI1QXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiI1QXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:23:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4EA6557B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/X+/rKf7QVMf+F1XE8PQ8UD8auqP87jO+g6vaR1LQLNpsF2Pxs1Ib6H7GQkpFROxil7+6MQK6tlhCKv3rOfDiQSVRnon3AwFl5FwEl/zEPMCwqp+8BwhOzjLui3i3rW5GdnJoFr8OwkutKnriEEAGa/DDOUpnqfeHqnTgrr3rElR3TB/G1NZUimGKq5qkFOfpnxfYmYEO1qlIBYv5mHFhPcJ7oDTjh5fyzTzCMVM2H9KCCEbP846O4WAAq9cl99jrUaSdiF1Ldf8sqyvlx1uWiXPKku13xrx7FTOke/oBucdOVW9JJ4MTL+vZYTAV5fVQeukjczR0ASoumxzkJyXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0O2EPnSnd9Pu5AXLwstynFIf3JJPky/wPADxDUoUToU=;
 b=LpbQGs+VTenkrqs1EwOK35ZKwrdwxTFAaT82KPvFC/asvYkznKs1SD/Q2F67S9HJTPc7NRvvn3AplpPp9XCzKANSVv7htIXgVj6F/od0eBujXkID6Ltef37CYP9lroiQHpuKJ+4I1cp67lxuUsalxflLhEtJm4LN1N0+gqQPL/63/aWJ4Y/JHNiM6UT2ss6sHwvA1r9YUOpLTBFZREZbZ059+Q5IW2iYtynJEQeTIl/PabbEtLMSQwtoWTbiosSOFRTX0Fmeg0hxXZQkrRpMSzB2dt+U0x7sMbfaLEt43hJBTMWjUtcPiaIH4IKoa2htb4ae27FcqxcSCwNSICXLuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=bootlin.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0O2EPnSnd9Pu5AXLwstynFIf3JJPky/wPADxDUoUToU=;
 b=rMPtKjbxMP4KF811fK7/6DZjSJWPXSHQryFoRPsfoEKZUPwBsAjb6BhAXB8MZefyMaPaHRZXry3al4XDiMks1Q8m5zGEx6WOGKevavjyggPBpH6flHonkN3CtkrrZRw0k12b43vHoYWeXyiFMjqKZ2Wkt81lKWrvxD7AaFAzEJ3ulfMvv+iK08TLuH6whmXDiBo9zQ5roISK5t5uqkn6TZqJ1SJ5WpxcUN4z6falWBaHChsvoPwKkQk7HeNEci46fTHamewso990tqtWNi4aKWzQoWUdnr1uhBIqIoh+XYjvJdgK7QtvLICGmAOpKlaeaL9jRUGO5x8lMFOu6CHH8g==
Received: from BN9PR03CA0963.namprd03.prod.outlook.com (2603:10b6:408:109::8)
 by BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Wed, 28 Sep
 2022 16:23:16 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::fb) by BN9PR03CA0963.outlook.office365.com
 (2603:10b6:408:109::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17 via Frontend
 Transport; Wed, 28 Sep 2022 16:23:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 28 Sep 2022 16:23:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 28 Sep
 2022 09:22:59 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 28 Sep
 2022 09:22:56 -0700
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <20220915095757.2861822-2-daniel.machon@microchip.com>
 <87edw7y93y.fsf@nvidia.com> <YzRT9hzoVU8h4q7i@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 1/2] net: dcb: add new pcp selector to
 app object
Date:   Wed, 28 Sep 2022 17:50:09 +0200
In-Reply-To: <YzRT9hzoVU8h4q7i@DEN-LT-70577>
Message-ID: <87bkqzwjs1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT022:EE_|BL3PR12MB6642:EE_
X-MS-Office365-Filtering-Correlation-Id: 68647481-83b1-49e7-bbed-08daa16dbf84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sd1qYqfTGHmUbn1xID2Xs+9XlFDuDiztM7R5pgwwDWyTUNDmTxNlH73VKe3xChJoH6CojbXGp0ha9G3jSKq19YHDbHQjqXaoStEwuADdfFMcPX3eszg0f16NPFbsozxBBgF8GkQodAz053In/12zJEzJo5L4Y4G9BGH1iII2BLBiKBtKXmtX8R3itDEREyYvrvhPoo0C/E03MCL6QOp3JfS5pJGxtfWoL1wV1e8ja+B/8EInILEEYsKKutVTi1suWShxUNELto8wVOI4XIeZ95HD5HwyxA7ovRvO8XiAQDCvDNRnh0KWFT3eZgZNkngChRs+ZAbIFWgzB5l4rsrNt41GGXTNg+LYMxsy4fDLbpzNWozVfdCA+s+jsLXEy6+GKF2vaAS53QHM2Bt6SyHs/8pog81aOe2ccfxbCDXXjd7JJJyFMqlBEphNQdlGqM1bPqQ493sK1bqjnSl/vRclbadjZ6bzgI/EN7Iow5YQE8tj4eZG07Ps7uRNDZQAfcrHXGP/VUfFV1mAVcJsOvQ7WnxSmpOiVSi7sSrMMXANVEGY9tm9e3wkYxWkGiX/PQNCSHCOR69iZUt153PnXdvwZFQdvsl7GJl3qlNPkH8oMfFP70qMsz7a+gA4C5M2j22n8BUcPkWH4hcg3zsQharOMxAk6sn5gwnzTaInMcxGY5EmWOzRoVggNOCdKQO0avOmenEQFDhyhYGrr3I3sWZUrPP3wYtWyWbP2K6egUBJUJhCG1gEHqu1NpB4BxXrWooqFihFuS913dWLq64TkrUIWgX2CMwlIebC7wKt7CSMq0oPRVAhKb8tGCZTZBvyyrujSXyhjE104x2rGmz0zEpxFBmaDj2chAUrg9bYUVqZ6HDQmL0UdSjALwg3/89ksbzy
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(8936002)(426003)(2906002)(5660300002)(7636003)(36756003)(40480700001)(82310400005)(16526019)(2616005)(336012)(86362001)(47076005)(83380400001)(316002)(54906003)(6916009)(36860700001)(356005)(966005)(478600001)(41300700001)(186003)(70206006)(70586007)(26005)(8676002)(6666004)(82740400003)(4326008)(40460700003)(461764006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 16:23:16.0813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68647481-83b1-49e7-bbed-08daa16dbf84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Den Mon, Sep 19, 2022 at 11:45:41AM +0200 skrev Petr Machata:
>> 
>> Daniel Machon <daniel.machon@microchip.com> writes:
>> 
>> > diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
>> > index a791a94013a6..8eab16e5bc13 100644
>> > --- a/include/uapi/linux/dcbnl.h
>> > +++ b/include/uapi/linux/dcbnl.h
>> > @@ -217,6 +217,7 @@ struct cee_pfc {
>> >  #define IEEE_8021QAZ_APP_SEL_DGRAM   3
>> >  #define IEEE_8021QAZ_APP_SEL_ANY     4
>> >  #define IEEE_8021QAZ_APP_SEL_DSCP       5
>> > +#define IEEE_8021QAZ_APP_SEL_PCP     255
>> >
>> >  /* This structure contains the IEEE 802.1Qaz APP managed object. This
>> >   * object is also used for the CEE std as well.
>> 
>> One more thought: please verify how this behaves with openlldpad.
>> It's a fairly major user of this API.
>> 
>> I guess it is OK if it refuses to run or bails out in face of the PCP
>> APP entries. On its own it will never introduce them, so this clear and
>> noisy diagnostic when a user messes with the system through a different
>> channels is OK IMHO.
>> 
>> But it shouldn't silently reinterpret the 255 to mean something else.
>
> Hi Petr,
>
> Looks like we are in trouble here:
>
> https://github.com/openSUSE/lldpad/blob/master/lldp_8021qaz.c#L911
>
> protocol is shifted and masked with selector to fit in u8. Same u8
> value is being transmitted in the APP TLVs.
>
> A dscp mapping of 10:7 will become (7 << 5) | 5 = e5
> A pcp mapping of 1:1 will become (1 << 5) | ff = ff (always)
>
> Looks like the loop does not even check for DCB_ATTR_IEEE_APP, so putting
> the pcp stuff in a non-standard attribute in the DCB_ATTR_IEEE_APP_TABLE
> wont work either.

Ho hum.

Yeah, they are reconstructing the APP TLV in place. The format is three
bits of priority, two bits reserved, three bits of selector. Hence the
priority << 5.

I guess the question is how far do we go to maintain the exact same
behavior for broken userspace. Attributes exist exactly to make future
extensions possible. If a userspace decides to reinterpret random bytes,
I feel like that's on them. But checking my what-would-Linus-do
wristband, I'm not 100% sure ;)

> The pcp selector will have to fit in 5 bits (0x1f instead of 0xff) to not
> interfere with the priority in lldapd.

Yeah, but then it ends up shifting into the reserved field of the TLV,
which is also a breakage.

Plus, if ever the standard needs more space to support 16 priorities or
16 or 32 selectors, the reserved bits are where they go. So 31 as a
selector value is not far enough from the standard stuff to be safe as
an extension value.

Um, like, I think we are not in the wrong here, and userspace goes above
and beyond to be broken. So adding a new attribute and patching openlldp
to ignore / bounce the non-standard stuff seems OK. Within the new
attribute, we can use a value such as 24, because 24&7 == 0, which is
currently reserved, and IMHO likely to stay that way. So old openlldp on
new Linux with the PCP rules configured would send broken APP TLVs, but
they would be broken in a fairly conspicuous manner.
