Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27C24CA7FF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbiCBO2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242911AbiCBO2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:28:20 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA142A02;
        Wed,  2 Mar 2022 06:27:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCTF6Zs9R43+IUhYkPtnyQaEvFjMoekaemvAXEL+QzoyjAbtUxQnUrRy8BF/vLRGSoPk4VtrVsghnUnXBTIBhgzDstSHQLX/8KhDnu0i56bKQ8NEifspHq0GrcWSBMOBjJxoLNgNqJqy7vFjSEoTxCQdMYI3aeUxtdpcnwdRHo2Hl7tDE/uT6/92JqPe/JNajfm8AUg+vYdXldDOxEhexfVI2aRuKZD8JzJIYVmR25WZ9iScuczqI+YsJvU76+MYdy4cypHVsPqARtAALdMyIomCBpu6ONX0OV13fIQ3AJuuWNlVYRoF+PyuGYs+znoYHw/LDnpLWtT6oR4kX5NvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzYkQx6oiFKZGJH3HcYWyegkTRW2fc+Fabr/hMdKWuQ=;
 b=asvG2I/LYkXwJ0ysiK7EdJtmNq15Gea0hyBX/1bm15EQ0+5aG38OOXgXeYsj1+wK8s4qf+fQdlxDGL7RsOxnyaN1oLAqLmGkbMXbzKJ4C5QQzMFi0/P2cKCZng3qBU9J/LCWX35zvhgQiMsL2oMXZGnki7yNnX0iqjV9D7ZZcqY3nvkR/bJ2ADsXVw/dPnFOW6kPDVUf6KicJe4XAatbO4ToUeAx1I6aP6LDSljo4qgQCkeAVu3rXUfBnMKRteISHTtNhWo+eQ70HcwX+LXT3KU+tlCsXLZtKzi/t9Ov5eItr/lKrwx4ooneoMj37472Fqoi+Te1KjVNWuWu6/ZzWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzYkQx6oiFKZGJH3HcYWyegkTRW2fc+Fabr/hMdKWuQ=;
 b=pav7rrtNK20dmfoneXSg0SQn+MUZ+Y3X7xrX/mO4u9gDSVqIvTtsOsrjyx9tAOtxiyUeQbwexNioGi7Y4BXXafRWG0pqOVbLzSw2vnGE4hew/RwY9iHsvfgk89SgInKH3/pLrsffMDzD/AFayM7GvL/UFIBpGifWi1WI6cx+PeCV3NFlqMTAsRCs7WlW5h7CQBjxhmjDP5h+akjlrND/hGYZgTd21lg8qXAYZizjXp8VzP1tkZsKe8TFNjfIidT4a60khsSyRJ37BwsGmPvPtcX/EyQhhsV/mATsXtyDXzi+vdg29Lzeqw03YYji3/Zc7iXoIWh36zPxnyUc38pbxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB0044.namprd12.prod.outlook.com (2603:10b6:4:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 14:27:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Wed, 2 Mar 2022
 14:27:34 +0000
Date:   Wed, 2 Mar 2022 10:27:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220302142732.GK219866@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-10-yishaih@nvidia.com>
 <87tucgiouf.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tucgiouf.fsf@redhat.com>
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abb09a7e-177b-4ac6-4c03-08d9fc58cac0
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0044:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB004410C82DDB2B62BAB29E9CC2039@DM5PR1201MB0044.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lCiDF2KRybnihk4offnuEuYGF5N876LeJO0nsGUdoCQoAS94gYPhF/HtZrtGk3ItFxB0vKkaat8o4Nx3F0p9Dd0CswZynFQmVzVlgGz2fQ/JYGea2geGVDuvkKtO9zphjr2EUZENWLfXhiasY88DmU04xqntOneJsFEMu2fxfDNPwsY6Br9sQgXCOKDx8DrsC1j1dJ4cGqwd13+rNtyeWSftDLZhMUn4VRm4TvHI548uhyz59AUDSLyBI1K6L1SLueIpSOWZMTMPTg8uka2M6z+SlaRAwuHfCMp8xw62z4H+IzyceH7n7iyYKaJdI5/2dXJoLynnh1pZQQuT7e8Z2+9yCCb8Vtv2nEUPdunOnQNVryh6fQY2y+lgNHJo+h8GmnINp0yIqbThizXVuoXf5FdIHR+QwYLLv3Jybb6eJD9vYuBumbNRyGYG6+wLOecbJvV4ZOFbD5evw2UyBKKUJYyJkfYbpGD0xY0aKyC/eJWwnXUNB2aIL/Dut1a1nDF60mz5Llz8jIOQ2zgzd+MEiKzq+AUWQJ4W4127icM+pWW724vNw6/DwRfm6Is5VqmH23h8Vk+9lX/kTWqdtTIiDTeVjeziY7tgBhIP0raGgngQcwx0IUqfXyPgJgu98/ATJ+fDyXC31N7layWImnbzUWsRi+T0wST5O38WUGBvFlq02w+rVdJ1CaJuP2GNra+hx9MDNNsBT+ACcczskV+5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6486002)(36756003)(38100700002)(33656002)(83380400001)(508600001)(6916009)(2906002)(4326008)(6512007)(86362001)(316002)(1076003)(7416002)(5660300002)(26005)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(8936002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ao/9EUrgYp9GKZyzyGS7airJvYPGCOOcvxa5B/+lZE/t72qrF0Q49S5OohKW?=
 =?us-ascii?Q?CmQvs7V0TavRxQYzOaNXO7X9GaKpwkLO8OvtQTplbagBMBlmGapHFxKLQlQY?=
 =?us-ascii?Q?HhcnKpjCu8/M3aYPFJ0G8RZvH0wsOVXIKpz894XjwZFrGUlIACWAa5Pdmqzi?=
 =?us-ascii?Q?PHrxz7rJgJgpi2sbhTzIttIi9Z31hWzDpgEw+GS0XWGis5Lrr3LTsV3xsSTV?=
 =?us-ascii?Q?f+wCjEUIgFk6e0sUgeVOxGLaUBvuQ22fCMCc2xVHpDTbdzmOE+PX4pV62gmu?=
 =?us-ascii?Q?T8z2vhEopyHbiUuQPiEyKB9Tyj0FaJDZEy72SrQZLyia9hwjfmCqQx5t52WE?=
 =?us-ascii?Q?u0qu9M56XamF/qiWtn1+bt2H4f6+QYSTH0gxDAFHnxU1ooO2ZLHubvG6aNU0?=
 =?us-ascii?Q?PCGHScEVHOpM8n1eg3QscQ0L/8wu9mCB8DqDpj28DHQK8aqaSHCfjsdS6v8F?=
 =?us-ascii?Q?zPq5m9fEfUpCcyxi8ZzYgt0SpOfB3+0s7f/+1OivUYq4Qlyi/nMg5MikXBd/?=
 =?us-ascii?Q?/ujoa0cvmejglU8GyZgh/qlrU0oHSeZHYmHLXObTN3sBslanBgcCOUvgdMRB?=
 =?us-ascii?Q?Bjd5q5GIScodP3JZQqI2VG3HDdH08x+/Ywo6sKiviwDLQfl0r5QvBLosRSXh?=
 =?us-ascii?Q?JVU/A7Sf/mblXqRRF8SAH6DjkswNAzF/bCjeZiVRpVB66DYJ2PNEg7MKz0Yr?=
 =?us-ascii?Q?2BRFj/7ELRSSV0tLXXSmm7HN6M0Gn7pVVTz9fU2JKOQyNM26XjjsA65xmtCR?=
 =?us-ascii?Q?c7qiUEyTL97c5NVQcFWmYK1rh/gP53Y7jCEJIP834ZOe3LWNXx3kIP/S08I5?=
 =?us-ascii?Q?BknqvuAvrDd9E4azSJPwo+rWsqY7nEg0rBFy09prJYyVSG8yKA5IrUJKOSC4?=
 =?us-ascii?Q?MuYoTeI6oc4wefUFuLETtzHt2lMeipjga5zguwP0d+awPdhmDFb/obekZOyX?=
 =?us-ascii?Q?V+Pd1wA8Jbf2TSgdX2Ii0p+KzgPoaadipoOeCfDmVrrmdXWUqSpRP1v1L1zU?=
 =?us-ascii?Q?YekeLUcgzllkNLpeJp0WF8m+qva2JuttYiTKtS3uAyLbMf/L+8MAKSH4eWom?=
 =?us-ascii?Q?NrftzEYe1KSkzvDWLPT5crF0lPI/8F6RVde8YV73qjveeMLYwwAW6FtkWIbH?=
 =?us-ascii?Q?SIPosrSJjLmDf25rTQ5fqqmO8t75IR+6vFciOEGw+02XkksJQNJC5p1ljG6P?=
 =?us-ascii?Q?8rtnEcuCL9EiRM1Q6KJF2ksiwGHP60ZOq3EgDAzONHitHLKQLAnL3dloFUCM?=
 =?us-ascii?Q?h7z7CUXnZHcnIROdacHeAhJVXXmP/IXffs6h/0oidXWCdyXgtHzH3gsyCWFS?=
 =?us-ascii?Q?k88BLSkN5a5l5/7xBkEhq6g9+hAG5CMIYHd/FgdplJMkJaPBdoZVUw8qEZ+M?=
 =?us-ascii?Q?FCSsNQU8+R+lZFHL003jnlxIco7SDJrYQqd8JVlaoCpXzP8mYba0JFcxo33t?=
 =?us-ascii?Q?sxfxVjtwFUe15nsqMhoAMZ+KEffWzzdqECDEhhXEIHmmjXe8RheBZKNie7qu?=
 =?us-ascii?Q?j3E+olOYQ6VrLIDPZRNFHXYoix8agxXNQxheVThL3YRQtKaXPRk9u4DhTs0M?=
 =?us-ascii?Q?qU/s9Vo+yULvZrQ75Ec=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb09a7e-177b-4ac6-4c03-08d9fc58cac0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 14:27:34.0275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLxLaye/wWV6dKfF9h4ipfuITcWNi5YOL+V+c+g7OMwyMYKCPqMAG3OCSYj+3xBQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0044
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 12:19:20PM +0100, Cornelia Huck wrote:
> > +/*
> > + * vfio_mig_get_next_state - Compute the next step in the FSM
> > + * @cur_fsm - The current state the device is in
> > + * @new_fsm - The target state to reach
> > + * @next_fsm - Pointer to the next step to get to new_fsm
> > + *
> > + * Return 0 upon success, otherwise -errno
> > + * Upon success the next step in the state progression between cur_fsm and
> > + * new_fsm will be set in next_fsm.
> 
> What about non-success? Can the caller make any assumption about
> next_fsm in that case? Because...

I checked both mlx5 and acc, both properly ignore the next_fsm value
on error. This oddness aros when Alex asked to return an errno instead
of the state value.

> > + * any -> ERROR
> > + *   ERROR cannot be specified as a device state, however any transition request
> > + *   can be failed with an errno return and may then move the device_state into
> > + *   ERROR. In this case the device was unable to execute the requested arc and
> > + *   was also unable to restore the device to any valid device_state.
> > + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> > + *   device_state back to RUNNING.
> 
> ...this seems to indicate that not moving into STATE_ERROR is an
> option anyway. 

Yes, but it is never done by vfio_mig_get_next_state() it is only
directly triggered inside the driver.

> Do we need any extra guidance in the description for
> vfio_mig_get_next_state()?

I think no, it is typical in linux that function failure means output
arguments are not valid

Jason
