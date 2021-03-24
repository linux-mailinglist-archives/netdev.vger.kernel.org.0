Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70419347A18
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhCXOBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:01:05 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:13408
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhCXOAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:00:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqH1wlZYSR7tiO/xUNHCqjvG5l2mAkN/0xmlc/TX8FpKF2ZGep+z8R4TMNSkfACXLfJBfyPguAGVRLYlJxnPP1NYVuUU8vvVZ09uTN9DcOBEZs/29c+Jsd8WNdtRmCzE7NFcbDkWmkP7AUvkOjkm1pjWWDuzIGMQbtw2ltxIiHdfRiNirTUF1g+RtrxrmS0VpeKyMrIo3B7nFOOD0PrNB72kWJASkuNUGal9SPfV9BeR51+DErLvZSU/UK8zXXV9WP0bUqO5KJjwW86tkW7QNBjBcwSQGdyVJashOhCsorbvvist4isTPt4tTMjXuMOvI4Em51tjUbDSQHwooVwUJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7XizWGPPtET12v8qQZ6szfG2xxU7S69gwhztDEjpVw=;
 b=Zr0QPupBFmzCYqukaKhwMDgiJzhxpOfFsgcTPmZdchuKsMrxcH3WxY0JzJV0EbDRTO4RLOttxXhv/wgkLgudCA1eMC9ATymvYYxm6V1zubXOqq4y/a7MeZAN+9aE8ZuXmk83nJkfFm3K4WvWSf5VrNJwsf9i+GQ//o0fIUo3Jab8r7hLCCJI3mGIGe2uok8/PzkDk8OMpQnFCeNY9eEqhXbj3Y3VZRNdOFDKEXrGfiiVaEvVhJyjjkFIBNDuq9q1iWZaOj1w27iTPtElLSk3aFO8oo4HIBpFKjEMj7vp2g0BzqFZzpiaWrW9Zi+ehyqbQetNoUJ3xzAFQaLJJMtkqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7XizWGPPtET12v8qQZ6szfG2xxU7S69gwhztDEjpVw=;
 b=Kd04lnarWTVYAehP3cxDd4YaEl+h+DMFI97J8hDsF6bcJJJgg/+Xcp2nk7VlS0q/tRS78AAhY3/aaZF9RtsoF4ynxzY3SY+z8SeTIhSl8T/hO8NZqNpFhHqoFWHnFRz1StRO+EycUpEa0yKr9stMJX0DNG2Sr91Xn8FiZw7WKEEMIDyzMWgdRzpX8cPJEeLru7UkFKi3ZFtquSGKZjlzLwNTtr1Pu7Brnf9Ijx2lpZNQxRuIOaCkl44fM8MK12IB2BoaBxVUUmlnwCPJa34SVcAh5EYWYTyknwvxpTLsD8kpDryqGapLsLaKy8k82Aoqti/2KsPm4zBFBjJVfxWMDQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 14:00:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 14:00:49 +0000
Date:   Wed, 24 Mar 2021 11:00:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        kuba@kernel.org, davem@davemloft.net, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH v2 08/23] RDMA/irdma: Register auxiliary driver and
 implement private channel OPs
Message-ID: <20210324140046.GA481507@nvidia.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-9-shiraz.saleem@intel.com>
 <YFtC9hWHYiCR9vIC@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFtC9hWHYiCR9vIC@unreal>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTOPR0101CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0012.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Wed, 24 Mar 2021 14:00:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lP43y-0021JJ-Q5; Wed, 24 Mar 2021 11:00:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfc3ae97-7ce6-4172-9a19-08d8eecd3a22
X-MS-TrafficTypeDiagnostic: DM6PR12MB2937:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2937F2C4438DBB22EFBFCE17C2639@DM6PR12MB2937.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bdAyIMhD4i1qu7ZN115rikZy5YllcNMLOHnrjl96SMQPSzNUHQEWBTGrqpbNwirtAD1wcF7raXwtqhzChkXoxSJPQo+V4dEUE3w5UnCFpUwG7ky4D7lW+vTRlGGfSCP7HRrt/4JuEdFh8KeNtHG23Iayt9kPQcdo1eMrPjcZpZKYYCfOEivHgx7/ZxdIDTOICUBI30kiHjFY9MPE8TtJiT89hTaa7IlpTPZI+BgdXFfXs0yKgEub+T/+BJ25F5pK8hPTi9w8t2HNX9dMGcA1XuJuYouEoVJAXKdVIOKoc0qr+q2v4RkTvlUksKJJ+fLqLL38+q7SwAxNFE3AqcFQBBP5ZF2OABHJUiXixTApUZIQYL3YVMXrY86WfUJ6Imczy2b94WZodnQh0E5JYytn7XVMY1mV9bHAhWN2q4wZfEn9uFtma5LEeOmy6+HvyeMwh8m3AXoTQAHjfdz3tuO77pHZ6jw1Mp3qAMfOR/KiwvsWGcauIAxhVW0IcddUMdphy2ZlPFO0J63jehZ9foGCcQxVDb/PJ23n0/2onKWIz5hscp1ly3DE0KxLe6rxohoj2qWkwHDHle0q5hjOTn15jz7L926K498dEZxrRb7xKxPjmfsa9IzmBa4tBz017r6Y0hot8bOPwErCSrtNwE2w3nTb382Bm+8WOcH/jwtJUR064vHfsiffyxnb9HFEkDJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(66556008)(66476007)(66946007)(1076003)(186003)(2906002)(38100700001)(7416002)(83380400001)(316002)(6916009)(26005)(5660300002)(36756003)(9746002)(4326008)(9786002)(2616005)(54906003)(8676002)(8936002)(33656002)(426003)(86362001)(478600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mXE18dLMguTlvmY+8MWXxwbopm21EfxBashYSYIHAmZXzpjTsJ17VaRpI25E?=
 =?us-ascii?Q?dnVfxKTBpxhutXuCAZshsg9zX1ahEF5nveSKdSWRpQ772Sttbkgd8rtfFmQp?=
 =?us-ascii?Q?9n/2QQ5yg21GsnUcBOeHnc+kKzeLWHeoE1zNtvAgVblAT2HTknNf10sN4YBR?=
 =?us-ascii?Q?G8wICb7+d/yW/SXQqbULoTJoSdVzWxcNvZ0weqNAKU+pJFQHZqWN/POV8S9Z?=
 =?us-ascii?Q?lb5qsStXAdlJXfQd3u6LZy0z9ryYcOvCJJc19VxPwPHrmh28yeijdU6sTfFa?=
 =?us-ascii?Q?++LxLlb9CGFR7Gq+2hcLOmXBOokILh7U4nWOXPfnVzJB/N8FtvLKgoKygspD?=
 =?us-ascii?Q?jAHAyzJxoky/lR/oUJ4WlcWHdJkfD935V95bk9GY/sEDsjBOtFgmDQDHzZ52?=
 =?us-ascii?Q?RHaEyJf+gu50owwQJP5R9jH+m3nlBw9BhgZlRqxqNoHZWQ9+rQnb1OxyXtK2?=
 =?us-ascii?Q?JZpIIPm99r3Hm13iSGVr/H0SLX23eXok+tfIJaWD9t+NJ8HIi8gjsqeuQgiM?=
 =?us-ascii?Q?VFdakY32DgP5qtRKrnEW943/+CLcsCuvlByAH1/KhXlrELKJdgih5f6E27fu?=
 =?us-ascii?Q?0bwtM01FE9JzxAF49vTt7b5cJKdwo0BMY16PDIkoOYpXt1aQ0I//dIDTLuDp?=
 =?us-ascii?Q?+RuvtOQxvN2diCtr/9RcLW+M8XYu65Mw+khjCTR1pW3gwP7WUuf+hdhjTFUQ?=
 =?us-ascii?Q?BFsAeeAMUoR8HNVqb4t5/VEwYaUcPa3oy59ahDAF1Ar/FOJcgUkn6hLSaZRz?=
 =?us-ascii?Q?sc6lBkteH7dDUdg0oYKIeqGwqOu+aMH2WvLAHzrBg3vPHv/pu57757+AMOVz?=
 =?us-ascii?Q?poX42IwK4ljS0WeaeND3PpAIQ9yEJjsNJyA98yKe6Agb4hQNix6edebXwypp?=
 =?us-ascii?Q?j9bp2aWenj1ccJvVz9RBRwc7hdPby9KqIsDVIPpT9We/1isx+8l6xI8gZZsS?=
 =?us-ascii?Q?NAx8pQ56b50LpqlWzcfSufErw1mwQt9Xg06BE/OX1NgtfYCG03UUFgfIdx+n?=
 =?us-ascii?Q?Mz6LoX5shCi4EV6nun9ye1f3Th1s4gN6ryyUnB9PNdRVUFtzQfdkUEdadGV+?=
 =?us-ascii?Q?uKGwpQzShE8KgXcZZY98azpGIlpeUv5M1+5AsCR4sUKT0+B3FS53PDLznO61?=
 =?us-ascii?Q?gdUhoFZy1ZJ4WZCFoYemuPt28+rTN6jbOrhq2DZCjL4WKmmqPRmNar/ZYiAo?=
 =?us-ascii?Q?6GKBSkYD8hMWOBxvv31Y8v8gqs9+ixvaidsBBLR3cTecbno0VmpxwJQygCLM?=
 =?us-ascii?Q?6pJh/6K7Ogz9lzXUGPwXm98qKsFP6kYRWaIpAR5ghfnyCsuQ2nE8E5Ky8I2k?=
 =?us-ascii?Q?VOgs+rIm2Y4v2GC02c1W0qbB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc3ae97-7ce6-4172-9a19-08d8eecd3a22
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 14:00:49.4182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXi7HeL786LCnkmbnVHFBdJS/U9txuo0Q3gTRO8MpOvRX9efqmvlObg+v+JTOz/o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 03:47:34PM +0200, Leon Romanovsky wrote:
> On Tue, Mar 23, 2021 at 06:59:52PM -0500, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > 
> > Register auxiliary drivers which can attach to auxiliary RDMA
> > devices from Intel PCI netdev drivers i40e and ice. Implement the private
> > channel ops, and register net notifiers.
> > 
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> >  drivers/infiniband/hw/irdma/i40iw_if.c | 229 +++++++++++++
> >  drivers/infiniband/hw/irdma/main.c     | 382 ++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/main.h     | 565 +++++++++++++++++++++++++++++++++
> >  3 files changed, 1176 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> 
> <...>
> 
> > +/* client interface functions */
> > +static const struct i40e_client_ops i40e_ops = {
> > +	.open = i40iw_open,
> > +	.close = i40iw_close,
> > +	.l2_param_change = i40iw_l2param_change
> > +};
> > +
> > +static struct i40e_client i40iw_client = {
> > +	.ops = &i40e_ops,
> > +	.type = I40E_CLIENT_IWARP,
> > +};
> > +
> > +static int i40iw_probe(struct auxiliary_device *aux_dev, const struct auxiliary_device_id *id)
> > +{
> > +	struct i40e_auxiliary_device *i40e_adev = container_of(aux_dev,
> > +							       struct i40e_auxiliary_device,
> > +							       aux_dev);
> > +	struct i40e_info *cdev_info = i40e_adev->ldev;
> > +
> > +	strncpy(i40iw_client.name, "irdma", I40E_CLIENT_STR_LENGTH);
> > +	cdev_info->client = &i40iw_client;
> > +	cdev_info->aux_dev = aux_dev;
> > +
> > +	return cdev_info->ops->client_device_register(cdev_info);
> 
> Why do we need all this indirection? I see it as leftover from previous
> version where you mixed auxdev with your peer registration logic.

I think I said the new stuff has to be done sanely, but the i40iw
stuff is old and already like this.

Though I would be happy to see this fixed too.

Jason
