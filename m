Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F9E4B68F1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiBOKNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:13:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiBOKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:13:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5DA10DA66
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:13:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ht+/Uz5rC6VD6xp7TuM2K96+lzQUdf3t6Ao/r2YliSsL6pznZ/LhWNCUVWYnFkyQFhFdoaTm2XKOM6Rq6/cEB+/nAiKdzP/3LSo7169OVu+at3O71AB5Y3bHKVZxVnNhKTkEY44AWZa0GBAwepsKbevN7nNmxfv2bZxko/mCgh6amBqVx9VVW3T1k4K8s9WA8iWjo9WNM/yCrdK2swiqFh5sXI9/BqU6GScXvVfcpVZ3JcDL9df0Yr5kd/x3q/ojZHfkOYCwR3u7GOKmNI4uUJhScsWO+OdvBZaNvhuRB+Pk/iEs3qUMl83rdTYZQqQfMEQyxgSm0AR9Ks8qpqPBAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qc0tajtkbEPKkDyFaFLgE0JybGSDXi3dz19OJkC7yfw=;
 b=LfiNF5gXovkDcGwDcWELFRCLaUO2IEq9D2moOzkwT5KHwFIhx1CCHGGzfbHmduQeypfGaiCSQUAkFVbABJQDSw4spIhjWO3msFAjDdtqff/ydYGSjEnAfZ9RlVHuf8UUhnmiG+P6phADqDApI2IR46U1LGzPIm77bEb8WP2eKwo4KOPCyS+Oolrxzd9fO1tWIWnpwrSRWitS+KL1qfQgzwVxVwNyLB5VJ66TDqwgbSmoe/h5L2cJpxRoRxloXUA9bayt6ODirjRhNzejW2N2Xolsvb1GFiBl+xmxJ7rRBJcIasSxYhmjwwwY/XluohjDmETUz8sRphw2hqbMLm2X4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc0tajtkbEPKkDyFaFLgE0JybGSDXi3dz19OJkC7yfw=;
 b=SbwuICNISDYRef0vAxQQ+S4t3z0ZHEnEUauZnMfO2XN0qnfQHMjyxMOmPrREx+Z6BOSrj+9/Gp2ys2M7eBj+ZDgUb91+3cdrXS26h+NiqDN1Dq9pVVgudFokmOggaapL2Un2IASquPzmKWMlQ3TIT6Mcn2o0JcI6zQAqasVb1yED9F475jD7FaI/kIm9rNSnV4YhbOtkmEztihqUh4l82VJOx/FGtsmcSE2F4Cadgu601xN0roKCWPiqSJ5m2grtOiIAdRFOicagdYwb8rSmc8PKBlQX4VigZTpDmKZYfACgejrm4Mn9Wb7ugYjk8tDdUOfHEB8LICPV3Raabf9IEw==
Received: from DM6PR08CA0020.namprd08.prod.outlook.com (2603:10b6:5:80::33) by
 BYAPR12MB3125.namprd12.prod.outlook.com (2603:10b6:a03:dc::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Tue, 15 Feb 2022 10:13:01 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::c1) by DM6PR08CA0020.outlook.office365.com
 (2603:10b6:5:80::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Tue, 15 Feb 2022 10:13:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 10:13:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 10:12:21 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 02:12:14 -0800
Message-ID: <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
Date:   Tue, 15 Feb 2022 12:12:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215095405.d2cy6rjd2faj3az2@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 062c9c92-d956-4dce-dce3-08d9f06bbf8a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3125:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB312551F0BC8BEFFE177B5838DF349@BYAPR12MB3125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XMJ+2GRp8r8lpCv/Xpq5bkycITql/S0KFwsH6vwm+S+mXRRhoe1J5Kz362L0rSOU/WA4m5ynm5YTS7d1jM65SLoGIzWQ47kVkLX+zicjuivVaFC7+VOy3L4/J8PeT6G3DNZ69Cy0p7qcUmEWvo92U/sbUwnU44x5CkckuF74Mqj+ayG4/3pZhLriK1AS/u/6taTHry3DU3nNQabXkAbS4DwubG4PgHwe8bVlv3y3cw8dwXinBVbIGPqZ628hF2AYE81RPlVFXSZUhjKcoaQe4VeOtVBed/xYnlxbsRYoCJQ3D6NiifD947oJLXCVroHM1jAnshlHQp8Vxiz6/OPqLurZCc+NYInSrKLGga2G/ww6MGcuwwfdlLGs/R+GGSLkb00SRRAq6lyAsN9UDKNVMfa1RvGBw787zlNopByHuPqTr3B43HSz2AH0vifDG++6+AIJXPSHvNeiZpEiANGlR7/Zg1lGYMRjYp2typ00KJGBb2O6wmfbUs1GZNJ3Os9E4IXpcBF36fFtl+SKRGJdHkOC6krr9OcQNzCQlYjyfNh0naTan2W/pZx4zXFQh5QAM7mxjYPe40FrFzo9ogDskTjMc1Vn/w+JCru8rYkfMph5XoIm31/EPkAiuNUReOARhj4BgpHZWggCBxjcZmv09Iu/kgVmxZAqsK1bKMal1PyXIHOKOmJhyzJ2udBhQ9dLNd6CE2WQKCTW3BCa1aFF0yF5QpM81NIQMDvUX3XBMCm/ABxhgj/BeElu2neze63
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(4326008)(31686004)(36860700001)(6916009)(16576012)(70586007)(316002)(47076005)(81166007)(8676002)(8936002)(356005)(54906003)(70206006)(83380400001)(26005)(40460700003)(31696002)(2906002)(82310400004)(16526019)(7416002)(5660300002)(86362001)(36756003)(2616005)(186003)(336012)(426003)(6666004)(508600001)(53546011)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 10:13:01.4101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 062c9c92-d956-4dce-dce3-08d9f06bbf8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3125
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 11:54, Vladimir Oltean wrote:
> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
>>> +/* return true if anything will change as a result of __vlan_add_flags,
>>> + * false otherwise
>>> + */
>>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
>>> +{
>>> +	struct net_bridge_vlan_group *vg;
>>> +	u16 old_flags = v->flags;
>>> +	bool pvid_changed;
>>>  
>>> -	return ret || !!(old_flags ^ v->flags);
>>> +	if (br_vlan_is_master(v))
>>> +		vg = br_vlan_group(v->br);
>>> +	else
>>> +		vg = nbp_vlan_group(v->port);
>>> +
>>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
>>> +		pvid_changed = (vg->pvid == v->vid);
>>> +	else
>>> +		pvid_changed = (vg->pvid != v->vid);
>>> +
>>> +	return pvid_changed || !!(old_flags ^ v->flags);
>>>  }
>>
>> These two have to depend on each other, otherwise it's error-prone and
>> surely in the future someone will forget to update both.
>> How about add a "commit" argument to __vlan_add_flags and possibly rename
>> it to __vlan_update_flags, then add 2 small helpers like __vlan_update_flags_precommit
>> with commit == false and __vlan_update_flags_commit with commit == true.
>> Or some other naming, the point is to always use the same flow and checks
>> when updating the flags to make sure people don't forget.
> 
> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
> into a single function? But "would_change" returns bool, and "add"
> returns void.
> 

Hence the wrappers for commit == false and commit == true. You could name the precommit
one __vlan_flags_would_change or something more appropriate. The point is to make
sure we always update both when flags are changed.

>>>  
>>>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
>>> @@ -672,9 +685,13 @@ static int br_vlan_add_existing(struct net_bridge *br,
>>>  {
>>>  	int err;
>>>  
>>> -	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
>>> -	if (err && err != -EOPNOTSUPP)
>>> -		return err;
>>> +	*changed = __vlan_flags_would_change(vlan, flags);
>>> +	if (*changed) {
>>> +		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
>>> +						 extack);
>>> +		if (err && err != -EOPNOTSUPP)
>>> +			return err;
>>> +	}
>>
>> You should revert *changed to false in the error path below,
>> otherwise we will emit a notification without anything changed
>> if the br_vlan_is_brentry(vlan)) { } block errors out.
> 
> Ok.

