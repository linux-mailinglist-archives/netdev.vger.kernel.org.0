Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DACD4A5E44
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiBAO3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:29:34 -0500
Received: from mail-bn7nam10on2075.outbound.protection.outlook.com ([40.107.92.75]:56224
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239278AbiBAO3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 09:29:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOG5iZxMQNeXLYJ2q/qOWuh8qvcYtzTO3+w88q8KmDKts797l5/1CywjTH5papD2HJ6Ezr+5ttewHcuS2Plutgi4fr/xMMUNzkMVhS41kP6cABWsWlkhO454k/GByONmokTs6VaNGQnWqy6YorcYU6BsTPkwZx2m8UcS9Jmj8ktxoFHN8RScgfHjPGUY7Af4PhdDSGTyDoFuJaC1zv/0VVv8bZ1WQ25R3lxwzZHHsZrCggDye4TvqeeQv6EnB1Dbo0Y++IfXOqvnKox8Ij8HOcVwEq1lxHYcmN4fgsKwb99ugaufPXlFZCefc7ZwTugP9SQC9kWNn2dXki+0GOtY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwDbJElzM5I49AeviTIseDwsUuQzGYJ+T5ETMxvc3/I=;
 b=hk6m4zDgjBUNHVTFY+W0oxon3sPWjgeRqFkNjwp/81n0SyXZtwahMBWqjvFQt9AxcBjw/mSwex6BAVWBZJ5h/Ov95kCeOtozxlakvMErt/PiHbtOZsZcRn8T0aMqDYcJO25nffI+EdwjCVBWJzzhCzoUM0gYovIP1W/jqRXMopmvlpfe9Df/9ZLOOm6mMQGtTW85TV6xonnPyKORC51kZQykpnXYhaQ+d+nUQYwotcPZFY0IUBz4uXqDgoVhL4wvZpxVEftGbxtimqc2GRi6VhUihcA15yO3A4MdVQMHhBAeSTtFIy96//ZmHt+e5oEUWEGB0mEMNIFbB0eRMc+njQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwDbJElzM5I49AeviTIseDwsUuQzGYJ+T5ETMxvc3/I=;
 b=FsOTj59Gsi2RfskxfwfPaDcW4UiccHelZZilQist8+1hwYGmCPBa5rO7R4dSWZWdUxJo9MoM+8X9cT56E5xjvK+wWCER1LfvO8wTYcHNphh6G2H4daEkOffI8bT1ch33C8uuG/JCewXovv5l8I1DX7ngnCn7V2eRyJQIRCUaH/SblOdsJnVezE3e32C/EDMUMArNo1C9LMEFfDl749NLcRVKlabO77EP82Pix3TE1j2f4/D6mXhWQaj1b51ZaHOgwkBSpjwq5bFpAizDKcvAAx+7Cz6QCV8BaGAZWCGdtQdtDjtGxUjG2Ex325hYFLN1dg+LiuN3xvS/HYoeGm/tqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3861.namprd12.prod.outlook.com (2603:10b6:610:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Tue, 1 Feb
 2022 14:29:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 14:29:32 +0000
Date:   Tue, 1 Feb 2022 10:29:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220201142930.GG1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
 <87sft2yd50.fsf@redhat.com>
 <20220201125444.GE1786498@nvidia.com>
 <87mtjayayi.fsf@redhat.com>
 <20220201135231.GF1786498@nvidia.com>
 <87k0eey8ih.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0eey8ih.fsf@redhat.com>
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f537ec9c-e38b-4160-f096-08d9e58f433f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3861:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB386159739719F7D10029AB85C2269@CH2PR12MB3861.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EEja3RMWWYdTtzCtJEvN9mYtPAk1Vyo3y1BP1Q/23v0zb1zoKSummr+z1qCPK8Eh1FHLz9+sFTAWreQkfc82GcFpc+81CVMnfL1Cq2t4phLusatf9tp2UreuNDLA7Ofr4S7Ef2lzAECWI4dD76C1Rk1hON8CTPwCuwSMP4CF0CLNjqyaCRZ25ea7BVJt/RA0/TKPVioMyWnXd7j414Q8dvPv7f4riEDyTJe4rYmtzFHQiWCkWdw/SOPvmsNdPQuCFvOrieF8BBshgo+ggqNOkWxutP4UqgcFzvyx+Sut+5UuECjOdbSAmRAB/CJMW6BRRgNjn6X0JkFTtVOdPsi9j4WpwmooLlc+FiGGtPaZ2UQVhscrMNNDFkm0u42huCTBMMIGjXPrvj7QIXfsKBfb8R1nJ2oWyYlvSgZeftG4x2mTtN++V6IWomDo4knc9XLHZNn3fVgc7N0S2dyB3fNWz7jJtJUNGqoWMCxhpAgpZkpmTPoltaL2r+w2Ui9bn1DbR+JpEAAr0qhCOPdbeifk4UuqnEz+ayW2QRnoczIc6x2oOK+uRTPWtPWMAOnCKVoSDwhwB6VAMzb2/H3U289M1E0QYWbIA5sEaL+zaCEBPaNNTJtm3E0mawHC8LQPyumAlrjKbRjOOZ1Okoh0JK9lOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(33656002)(4326008)(6512007)(8676002)(36756003)(86362001)(5660300002)(45080400002)(8936002)(66476007)(66946007)(66556008)(83380400001)(6486002)(107886003)(2616005)(1076003)(6916009)(38100700002)(26005)(186003)(316002)(508600001)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HwwsEAinePSXYMc6X6as01D2P+Wi84Hap2WoStFuqPFSgwvoWF/y2/8lKrj7?=
 =?us-ascii?Q?hZGrUuRKo3kYUFjb79vfW5Q8/vDpez62kV+dL8NDqNIMmKbZQVsy0sasmSF9?=
 =?us-ascii?Q?vFUK/sL6jdSVze94hxmz3zYAPwSWRUHB92lJnZDe4ah+2crgQMsmBcOph8c1?=
 =?us-ascii?Q?327e5Q78zMKxMayS3NXo0et8Zgk6otqj8ahAhMkI22MP32KMtVtAcnQfte03?=
 =?us-ascii?Q?or5iupw3YYZo83zdksVVsbzve3OYMuBOoey94fxuICy+048HZUy/S30LhfGk?=
 =?us-ascii?Q?8TDXh+dI+6oAw1kTa+OaEIbKaGK5/vUerDes9rwG6i0DNwTOX0Op/driPIw1?=
 =?us-ascii?Q?R+iF5UeiQ6kKsBtaxuwPUUxaoiNXS58HewYYTKAg1q/TFLRwJtzZvhQ33m49?=
 =?us-ascii?Q?MTJRAxh/DNVKJJumzT4zNAPpri2NJ6Jq7BGBDvARU47UEyIAXGlhAeJ3+Cl6?=
 =?us-ascii?Q?fHy3gFY5Xb/JewYFzWYG+KrjCqJeU/oqxwmMrv7tNV75PI99WGFPeGZxu6DL?=
 =?us-ascii?Q?NPB71Mxts0Fs1KZ4o59gA4f2xzevI5y2FzM7qI2joeG9TgV5klQ9TVkisucx?=
 =?us-ascii?Q?sN72y2QAGmMg6NkTWYlia4L6PZ84cHBEvyN9LnUx3B5kOM2hjKzcZRcMsmpD?=
 =?us-ascii?Q?ajDpI1Um+ejMbUZ4BgYJSOkSpkM/yAQBH/jwl9JhzLoZlL43Vo1/7yzHwozS?=
 =?us-ascii?Q?yQp4jY/7Z97slcso6BVyGIAJnNDcee/rzQuyI3Z6CwuLQnDBKqELMT/cvvp9?=
 =?us-ascii?Q?U/eYtfLC5UEDi/HmiHwNKd9h/7+1xIxiGUmN5TSWL/7NuNml5fZI2TP0lsfp?=
 =?us-ascii?Q?koX9fS4KBkXCW5pfWijZXkPVOeWq6iBYM3joK/Z980NZmAdeyCd2DmWV6YN/?=
 =?us-ascii?Q?sM0NRELwHdtEB7MdygYHmO0ECN5Y7hVpuaGbxI0BV16I+coiBk8pp3tC43Z5?=
 =?us-ascii?Q?lqa/7jgt5EoswO8nxNrwYAd+bdXvLIr+BhTiwfkI4jBs8W5u6kBsb1So21e1?=
 =?us-ascii?Q?miBVARZJLoiX5y4gwd6vRzgVna+mytCJDdH7WPkVXyu8+K9q2NUnB1rNIa0v?=
 =?us-ascii?Q?86OSiBw5jNCxbH+ww96+Fs/jNNNupZNHggNZkAv11tOxSAYHhLXdTz5RvffM?=
 =?us-ascii?Q?siU6CvDJAnWnirQ2/7ldZu+o7h3GkHaoBAbew4l1OLmFe4/XnxgXxPCEW2/v?=
 =?us-ascii?Q?lFuUH9mQl05MeJOUPImbPftUMWJYJd0t6iUaAGB38H1AOjl9oX2/1CJYY9+R?=
 =?us-ascii?Q?KR3ENR8VCP7WZ2K4fRPuHFsrvbTraXxAhcMvDHhXnw1z9bSCn/Hr0oNoESk1?=
 =?us-ascii?Q?qElT+O1+m/RcssA8rt0b7n2+qT5zJfaW8BF8b45kckOx4G76+tsdAD4X/iKK?=
 =?us-ascii?Q?sxJ9U9dqtyMcx2ekqoMGnSjO7nFlDhzntC0Uaf5sRtXSv+AULAuC66rpfyI5?=
 =?us-ascii?Q?HuYxbc6ni76DQ68rEsYnCTbJ4+irHkynnhHy0tXww8nrpON1NCNBEDApQFw8?=
 =?us-ascii?Q?CnrXYif5FW0HjDAXt06xLx1hUK2Js9sPEmE6PKq4Prkbl6AK8Z6sgsvEf+oi?=
 =?us-ascii?Q?6r/XgEvCiasVdFVGYLU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f537ec9c-e38b-4160-f096-08d9e58f433f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 14:29:32.1921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYiJogir+jAtnDwBzeZ5HIZVnBP5RqrPhWnF9LKNmg0yp/Bc0ZXI6kIT8lSiHFPh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 03:19:18PM +0100, Cornelia Huck wrote:

> - remove the current QEMU implementation of vfio migration for 7.0 (it's
>   experimental, and if there's anybody experimenting with that, they can
>   stay on 6.2)

I think we went from "we clarified how the ABI works and made
something ABI compataible with qemu" to "let's delete the whole thing
from a released qemu" rather quickly..

To be clear this is still all logically compatible with the v1
interface, and we might, or might not, want to use the ABI compatible
version we already built out of tree to support the existing installed
base of qemu.

Dropping the whole thing seems to only make things worse for this
ecosystem, IMHO.

> (- also continue to get the documentation into good shape)

Which items do you see here?

> - have an RFC for QEMU that contains a provisional update of the
>   relevant vfio headers so that we can discuss the QEMU side (and maybe
>   shoot down any potential problems in the uapi before they are merged
>   in the kernel)

This qemu patch is linked in the cover letter.

Jason
