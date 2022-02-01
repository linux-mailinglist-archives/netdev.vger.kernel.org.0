Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D684A6531
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiBATuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:50:07 -0500
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:21504
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231716AbiBATuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 14:50:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWSVtJ1BB4ak4c1JD2zXFB6Osft3n9O6IzcKpO6kAPisxDrKAqCJSKgvBSnPYzxqb7qT5BhKTkWJvgvIFmVS3ilq3WC5MWNodiLu7ZWkEzSxEcYIdL53Gj+RzvhqtQixzDVTRwWoqNp7Oc/1i4Vc++06qx9d/EChBlvYcvosrMwOP7Tlxc0QHkTyo5yUjcj/fD2TzQ++X1UspQq2nl0KC0/lOoPar4ntS0xAf5eNO6cyFhhmczWuf5bKXzugPj1cV2p0+Rx1HtquUUbc2ryp3r2423h15Abw7RsdLG8nUP6ejDXTVABL2avDjArIQw7/h9Dt0pG2sjplYhxZ7FQW5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJvFfqTNI8x/4yjkmH6OeF3Ek1QaF1XoylhcACSe/9k=;
 b=lyrRvf3GASOYZOhs9HzhjafzrcQo+aDVI5ufRYP+pxakl74JN8EyBZOk2ihKQYdLJQiy73r5T3w5jN+rLwgXuCvkIEhUYwRZbaqwhCAmlWGH/+LWaIF+I0tOCMC3cseP5KRPZowIf9P01soTckCbzmru8GBf9VB145Kttr9SyNVAZEIULH+YJcdh/Eyl/kj/ydVXRyvKZqJgW8uTG4HZhYjojixuEHGyibXFksRmSyqjI00aza37eYQS2vAyKHAQaFOaYNPHawgRg/xVjjEYsYgrPkjezD9n3zdiQJOzw493TNzofkK/MtL8hjaQsoAYu9ZfesScS7I+HV2TIhumuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJvFfqTNI8x/4yjkmH6OeF3Ek1QaF1XoylhcACSe/9k=;
 b=nrExDWBUufIL6di0QRYoeDfzfYFuUpOleFPlc0uSl7euxVeAt35WfMzsD4vN9eZkfUIk1Jrt4ehykEmJ4tcGFyw2P6Uo1mcdfEZc30KhEIoclhQtDSfQRtfVyRV4bfeaFz0+xQkWwu/ygxvzwpvQ6igVRZZDq5ggolMfUv345epOaTaRbLIXl8GcUPeZ3BLrO8jqgyEzog0mrdROnwyDx1yxDeWsP+IhGCAVXRDzGqGIA/G/ycXzafndJUbOCMCdK6AmPtpg8z3gT06vzcp9Ol14nKaXKCKv9B8izpIUXfe2dlREgMl98LjaATU1prA16LBmApRBSudfbUENKC8ilA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4249.namprd12.prod.outlook.com (2603:10b6:5:223::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Tue, 1 Feb
 2022 19:50:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 19:50:05 +0000
Date:   Tue, 1 Feb 2022 15:50:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220201195003.GN1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-10-yishaih@nvidia.com>
 <20220201113144.0c8dfaa5.alex.williamson@redhat.com>
 <20220201185321.GM1786498@nvidia.com>
 <20220201121322.2f3ceaf2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201121322.2f3ceaf2.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:208:23b::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c115454c-6d05-4f83-747f-08d9e5bc0b48
X-MS-TrafficTypeDiagnostic: DM6PR12MB4249:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB42494DE67FDD006DADF16C68C2269@DM6PR12MB4249.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTTgzOFrkww65ebgTTeW3xK9IWIYBHHhSnCIyjXQRP1QGmFfatT5fRYxd6g+3FfU/xIA6641j4ToKP8GOGRmvBkoPiUleoQARTCg1bzlHwtIC6pccGJUBlQcpqdLCnbfiX4G4tdVUFgsUTPzAlgXU0qGdfmTLb5oaYznROHWsO8OLEHnaFskluQre0b8Lg0I6A2cP/wqaWXhdh/lm80DRRdWhW81GT4EFyfP9r9294oPkNM4Hi+/pHTI/LEbaXa0MqVacLpMxE3p2vc59K1BgkRv9YbUN7lNi5RiKXPM9wmLe+B6Grr7ovbd0fveD8j5ZCIDFxf+sth7OqqKHXjQrCa5rXHh5OIUFnGdlKE7ydjOenq0CJS6j82v0kLviUkvf+9j/DMsHoQ8iBDZQ84d2RFH23j+nTq53sjjf8rF5O420Rwb6qURdCSt4UyMRoQrqBlgRw+kWQHxC3pcXXPxlPCP8npg4Ai2TpyzGij3E7jKXnjJSE5Y5sy/5+xXK6oHcluQ2wEwb5oQzczW94+r4N9t33TpbjutDthF947o+sYX3AqKIFo99nz+VGTq/vjHM/n8BFwJ13gorwDl0gPMtlmv5KBMR1CpkD8TKUnBZCrkIeVrp4exjL9o7MiBNcynJldaioYxEAgFrm3yZgb4Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(66476007)(4326008)(66946007)(8676002)(508600001)(66556008)(5660300002)(8936002)(6486002)(38100700002)(36756003)(83380400001)(6512007)(6916009)(1076003)(2616005)(186003)(86362001)(26005)(107886003)(2906002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w5rsaQEsHXBPlciOTe7lBRUNxfKO781Ehqji0s6u8h+P1UM3jnpJZN2UHnWQ?=
 =?us-ascii?Q?S/hyRmtmt0uUaPyIBEfrHZAalkHBnbqcfOe860n2UC+kPN+5iA7aZoXNryXZ?=
 =?us-ascii?Q?s5pctaqxTYI4YsB4PoiHk6KG1yVUdKMHo1mCLW1+duejXeK6/twsdWASRekJ?=
 =?us-ascii?Q?eGvbLGmUt03CIpkp8mkzz6lWtaYK9//+NCh5QjY2RSzxLX+iSt78N0LLqh52?=
 =?us-ascii?Q?CoyUpI8dTpn76PzOJRO8hpRM5S6G3HV7tbfyhSiNwYL20T+OE+jwX123Gyvc?=
 =?us-ascii?Q?RTXLuJOv81Lr6OIOyA679aaDmLByHlacezHzVOpFKgvQ+aXdSbHJXegdHlT6?=
 =?us-ascii?Q?kg6rn6KS/7D0m8xTld2hY1kAWML5lE6VIh+pjK/abhNXtqTckoOpuaXsZMEt?=
 =?us-ascii?Q?w80uIzYAUIYoS6GpGLSCcjt6aDeFY1U9uTkDvo8aUa+jVT4FwiB7DwtDBrx0?=
 =?us-ascii?Q?GbWPltQn6oyrMW+4uj1eUd22+WaWCJtnmSsMrNhIs34St6H8I0dC8IRPSc3t?=
 =?us-ascii?Q?foV8xSP4IZ5afPAzfVXlVjgxfem1smLsgV9kVBjr1DWZPmhupHWN4GCVQplg?=
 =?us-ascii?Q?JU+yJ6smmi4Easf9K+JgK2/lDKNedvAYb+lSaD1LYaAHx9EDSefrcdNVEaSW?=
 =?us-ascii?Q?ie1X1of/CQHFM0W1LVFzSGOEH2m7aLetosTrG/jz6ZO3kqDKkA7GZ8d4lFZD?=
 =?us-ascii?Q?gNG32Iz4m2YRu46THSvSPVqDr/GU8zscNrGDXG/DDaJakgezluoZ9Nez7Qlm?=
 =?us-ascii?Q?f/DwdR2oFojZOYgBKcmMpj9qQVzjL6nWf9iAQL8yzZgK+4S+0IjZ1YG7Qh3x?=
 =?us-ascii?Q?t9R49Wugq6fQw1ZVPEtkivVFvfMANEtJ0dKj76SoiGgM0AG3Fh2dTPxwCslH?=
 =?us-ascii?Q?aVbR5z0Y8po8ku7cWzR1Co6DTbVZ+OHZ8nYkYlb26w7Kk45o/hifsgO8YPtU?=
 =?us-ascii?Q?08CyjE31HA+dvbQZ7KwZfMun9BZXCbyIYPai4y6Rqh9vVjHYOkQA/AhuA6Qj?=
 =?us-ascii?Q?YKjAgl9v5DXnviBZYMPf95Ewf/Xj1DsVyHFzJVVkdpY2KwTOR7OkgLoDgA/t?=
 =?us-ascii?Q?dykByT4iwuQZ8NCRGfYXpDT2F5IKRFgbRgFp8FgDexf+Fsutj4KVvJ8GETxT?=
 =?us-ascii?Q?PbpE5PVcd9CM38QZokK8OQGPX0PaI5EuW/HKlEcZIMx+92ih166jqjhX8SdX?=
 =?us-ascii?Q?6YWdDfQWgiafdv3GJLYHwtESQqwqD64r55YG9cQ6Mq/uXiHU+5vB3Ijrd3LR?=
 =?us-ascii?Q?CkRw5ZlnmQd1iUSi1UesBZqKd+iF2gX2IKPiMszKkwq+k10/4JWvxcd1ZHbA?=
 =?us-ascii?Q?EJ8dLmXd/oGTWFWKmr4GBCPFVeX/wH3Hp+sGtTjZEsh/0sHHS4hLt9yzxaBH?=
 =?us-ascii?Q?wvb6uA9Nd62NQJ3BXYd5/VhNpYz/YWOW7XvV3kxeXdp+YRx8cO8GSNDLdjTE?=
 =?us-ascii?Q?5RH5diiL0or4W1j90TQHfTvJcVKrv9vZGm6QmeoNyeiogHaYTSZm7g7OJ6yt?=
 =?us-ascii?Q?yAR6mwvcWfDqSDd1FokgAUs1f/qIlNkEdbVdislaL2sdSHiexQNdku2Et/E1?=
 =?us-ascii?Q?b0vMourGEhDi8lsb6Kw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115454c-6d05-4f83-747f-08d9e5bc0b48
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 19:50:05.7733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePbH5nwr5RCBbUcMXYspaYoz00nUiEjyBMzKcgT10+XJoUsv722lAfudYmjUNInx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 12:13:22PM -0700, Alex Williamson wrote:
> On Tue, 1 Feb 2022 14:53:21 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 11:31:44AM -0700, Alex Williamson wrote:
> > > > +	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
> > > > +
> > > >  	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
> > > >  	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
> > > >  		return VFIO_DEVICE_STATE_ERROR;
> > > >  
> > > > -	return vfio_from_fsm_table[cur_fsm][new_fsm];
> > > > +	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
> > > > +			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
> > > > +		return VFIO_DEVICE_STATE_ERROR;  
> > > 
> > > new_fsm is provided by the user, we pass set_state.device_state
> > > directly to .migration_set_state.  We should do bounds checking and
> > > compatibility testing on the end state in the core so that we can  
> > 
> > This is the core :)
> 
> But this is the wrong place, we need to do it earlier rather than when
> we're already iterating next states.  I only mention core to avoid that
> I'm suggesting a per driver responsibility.

Only the first vfio_mig_get_next_state() can return ERROR, once it
succeeds the subsequent ones must also succeed.

This is the earliest can be. It is done directly after taking the lock
that allows us to read the current state to call this function to
determine if the requested transition is acceptable.

> > Userspace can never put the device into error. As the function comment
> > says VFIO_DEVICE_STATE_ERROR is returned to indicate the arc is not
> > permitted. The driver is required to reflect that back as an errno
> > like mlx5 shows:
> > 
> > +		next_state = vfio_mig_get_next_state(vdev, mvdev->mig_state,
> > +						     new_state);
> > +		if (next_state == VFIO_DEVICE_STATE_ERROR) {
> > +			res = ERR_PTR(-EINVAL);
> > +			break;
> > +		}
> > 
> > We never get the driver into error, userspaces gets an EINVAL and no
> > change to the device state.
> 
> Hmm, subtle.  I'd argue that if we do a bounds and support check of the
> end state in vfio_ioctl_mig_set_state() before calling
> .migration_set_state() then we could remove ERROR from
> vfio_from_fsm_table[] altogether and simply begin
> vfio_mig_get_next_state() with:

Then we can't reject blocked arcs like STOP_COPY -> PRE_COPY.

It is setup this way to allow the core code to assert all policy, not
just a simple validation of the next_fsm.

> Then we only get to ERROR by the driver placing us in ERROR and things
> feel a bit more sane to me.

This is already true.

Perhaps it is confusing using ERROR to indicate that
vfio_mig_get_next_state() failed. Would you be happier with a -errno
return?

> > It is organized this way because the driver controls the locking for
> > its current state and thus the core code caller along the ioctl path
> > cannot validate the arc before passing it to the driver. The code is
> > shared by having the driver callback to the core to validate the
> > entire fsm arc under its lock.
> 
> P2P is defined in a way that if the endpoint is valid then the arc is
> valid.  We skip intermediate unsupported states.  We need to do that
> for compatibility.  So why do we care about driver locking to do
> that?

Without the driver locking we can't identify the arc because we don't
know the curent state the driver is in. We only know the target
state.

Jason
