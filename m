Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EF160E431
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiJZPKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiJZPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:10:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732BA6F546;
        Wed, 26 Oct 2022 08:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/IPxq/7gvm+QsOHvtM2Gpgn9OSQlQsCELlNqyMiuooeEDtbGdjiXjoYH9gVWmccxgy1WaMu1w94IB/vAkRDONrICo6Et0+nR/HEJGqWFJK8J0wIS0qxCP4VXc4jI/s0TbsB2FG+4QsmQ3zZDLryX1CmYNVuLZOVascPrCbl5bbCC25QZSDI5HJw5EB14qWIKsTax8vpEP6TiKuksLqUd2GUOYx8qdA4+KyYyJDVch3Tb49U+dlDf8mIE5TE0BcdTQKAMRXo6X2Ed2agJ1um+FTZvdueMHtEUyEkspzGCGXdrcfNbTMbMQY00wPaoFt2qksIqQMJJnQrL9/fxwX0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uA/Fq0ni94/IrNdZEN9sB4UwWl/+M80zQAq6pn/WU/4=;
 b=PJro2mE+MWq+/QQi4y6vXd9ymjnoSvmicdi+Gd126JK4479zUqDgB4stbEGdV73rW+QkZcb7lA0VHNRBHFHY77ekVUT5WgYXrdiNVsdzhMA2JUM1kP1yl2xIi7fOosfH6mjWy9dBSBQ57Xdu2Hsg3BF3rKXIPkTrLC3nzE6Asx2uPDKNG7RgWlKqaK40LjcoAzI1gfwqVfUCWoaJxn7LohgMEqkSBEqNxo585HGeRelFhxp5IBgSKSobCggton9BbWzyRhbFMYvhe6Fjmqr/OuDBRyLU5LYuOa3wcV/obkhKIdibK1R4k44o8dB5YN1xcHj15tB+TI7F75dZOoAuJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uA/Fq0ni94/IrNdZEN9sB4UwWl/+M80zQAq6pn/WU/4=;
 b=MNI0tWyQALtannSq31DSYBHkiBRfCDl7UUgTfQd0ko0Rq6M4KTGHXC82UG8SXOxUm0/0tK3aYpgCU1N959hjw4OtMkf3u/vqr+a2Mjv58caR4Obiqnvqxzho7DQPsAknqfDWdyBSFM7x7SJq0mkuuSOGH2tlD8x1gXoH2J1MitGvCCsPQ38p8PFctc0AMAbMzsJhf0oO8N+RujSFaxHckG/6xT8BOPN7Tohr62CwV1caROzqeB6hg/OvUb9wkD6zLoREoHwy33TQkc4FNFhZOSMa46uKC5Y8+WpB0C/WmOe73Q6s1qXXslIvn1rCWqn6j7ISQKqG3w61GqZThFcKVw==
Received: from DM6PR17CA0022.namprd17.prod.outlook.com (2603:10b6:5:1b3::35)
 by MN2PR12MB4389.namprd12.prod.outlook.com (2603:10b6:208:262::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Wed, 26 Oct
 2022 15:10:47 +0000
Received: from DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::e9) by DM6PR17CA0022.outlook.office365.com
 (2603:10b6:5:1b3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21 via Frontend
 Transport; Wed, 26 Oct 2022 15:10:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT115.mail.protection.outlook.com (10.13.173.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Wed, 26 Oct 2022 15:10:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 26 Oct
 2022 08:10:36 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 26 Oct
 2022 08:10:32 -0700
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-3-daniel.machon@microchip.com>
 <87zgdizvfq.fsf@nvidia.com> <Y1kmBMXluPI1Wmu/@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [net-next v3 2/6] net: dcb: add new apptrust attribute
Date:   Wed, 26 Oct 2022 16:55:31 +0200
In-Reply-To: <Y1kmBMXluPI1Wmu/@DEN-LT-70577>
Message-ID: <87fsfazkm2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT115:EE_|MN2PR12MB4389:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e97247-72f0-4ec8-ea1e-08dab7644298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2xkE/NMAJTek+sOqXt3Qiyf2O9SMleVn2r8r8tXCXA8KsNCwitDg6Pq9Q+d/6YQyf94zm9/Ev4gCFHZ+MrsikEIm2e2qxXqxJU7EFcIwewUqhi93jxi5lSnHE2PTvNK4GsMNDEfaXXpUgp5pyrvlDzFnzNqHfJzrmwvTlr87KfBt9yFaMRWV1oyG7M2UnRKe+wdPs0u1R6oHN0Wm8mcQGbbEUp/0JGVAaM9jB3sp6x0rXIalpd4jBq2bL6lCcFJdPQ23anzd+Smf82BZXOqcnxepmRw8X/FUXEuv71D8WxUuJWo/dCLx5HIbGcoj+ILvzAPsIOd0H+HdPJrFpjqbmC89VJHQxuuhKZFRcXVZpKQUDQf9TPqPED2VZ+SD8Yy9ATvmL0Q+VjYMWIUqnco3hg/6cnRyebMiyEruNrM8pgRMBE73jRQKc45R73B/0aLY9HeWlpyXxbFfzV0yJ1OZtwUmnVSCk9g2uUBiy39732jIRw6h4uZfQ+rPh6LIBHIKj7dBOqiGJKr92g85iOyqFSwW/ka7YiY3YshM7Q05BAf3pLg4ZcO+0WroHTmuNK0vAaA+8dL9FWJur1LhKOR7POXr9pOsMxfqkC47W0+uW9gcL4iSM/cBa08ECWBl7qQbBGSzuNi2Y2mliDDJJ3tJIQTwzPUtEdBfL81IhF0QC8dmOM2R5fi1vzmzPvVMU70ph/wfTpBXBuQhVLJbv+qEmoKZ95xTJqa5C2Qf1COQDnZh+AutPwfYG5NGyDEpkyil8AIjmRKFkWdBGvb8Vuqvg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(2906002)(5660300002)(336012)(7416002)(16526019)(26005)(41300700001)(186003)(2616005)(8936002)(356005)(7636003)(4744005)(40480700001)(86362001)(82310400005)(40460700003)(47076005)(36756003)(426003)(82740400003)(70206006)(36860700001)(6916009)(54906003)(316002)(478600001)(4326008)(8676002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 15:10:46.6714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e97247-72f0-4ec8-ea1e-08dab7644298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4389
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > +     if (ops->dcbnl_getapptrust) {
>> > +             u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
>> > +             int nselectors;
>> > +
>> > +             apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
>> > +             if (!app)
>> > +                     return -EMSGSIZE;
>> > +
>> > +             err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
>> > +             if (err)
>> > +                     return -EMSGSIZE;
>> 
>> This should return the error coming from the driver instead of
>> -EMSGSIZE.
>
> Hmm. The question is whether we should return at all if dcbnl_getapptrust()
> fails, or just continue to fill whatever other ieee information is available?
> Seems to be like the rest of the code in ieee_fill() just ignore that error.

I see. I guess the reasoning is that one broken callback shouldn't lead
to dropping the whole query. So yeah, let's do what the rest of the code
does. But it seems rather cavalier to disregard error codes like this.
