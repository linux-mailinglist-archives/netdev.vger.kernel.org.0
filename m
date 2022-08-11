Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A558FA93
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 12:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiHKKPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 06:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbiHKKPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 06:15:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15556B1D1;
        Thu, 11 Aug 2022 03:15:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27B95Qa5021745;
        Thu, 11 Aug 2022 10:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=NvVOI+4quAF2kQHc2Ph5rJrsILOCj/jm29TavGuBEjE=;
 b=FbCn7C4PDtb4+vCUGbpZ81nY4WwtDtlErs5jGQlg2U9JNhZMGlcX0Un871oaM3Qsi2UH
 /fPamuQGuuT6Vp9FOopSPJYf9UjhidcEUNcMA0flq3TC7go79nwmKCQ/jEk+aUb3TmoF
 hEMuJqOI2UtQt3BPHxiLCJbNI0NbOxxiMSASoPK6n07pmDA7OIlOqaKHtaI4NorIS76M
 0CwZtEKEogo4Yb3jW1/zA88+tjGKvhIQJtLhCI1Z9BUZkQaEmug5kqZitpPeEwKQuwNg
 8ryHDjvJL3rKpHH5hvDTLwmuQtuVcX3IPABTpcud/dli9I/SOrsYFMnhtloQNKW3shcR 5g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj48wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 10:15:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27B9061g018969;
        Thu, 11 Aug 2022 10:15:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjycyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 10:15:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/WPuPGNkQt2UktSj+XIsiLdJmuH2n8C777af8OA5lRDIaIGThc2BbiTodL6Bb8NMS18FW0Oh7vWBQsQ36RZHPNcUkRCrpyKHJxL5IgwwQXCP79xRl8wG8rEnWVcverfs7z+lBNRmDR7LWhmk2EcWnqzGR6srCpG6UBNI/TodCZb39c04Lcg0uNxOu9TkVt7FEk2M+xy5qj/3YQFk2SNc6BRtF7N+14PdFue7VFuNJT0SRF9o16lDgyQipFZm/GGg75djAZu4Lj5cSYOuW2zAN3V+spIp6fW5t16OTUsZLGzb+qkzvVQQ96eEYeTMMouSTiqHbhzU12ZkQknENogrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlDDiVmnXybg9C6T86G1EMm5/WFg5HjeAb+PKnAjEKE=;
 b=E4t5RcpSXObT8KtBZZkDwnxlXh7VY5bvFxp6gBeEy+R8kVteWyIu+334tAkwZ+Sec72wm94HuRjwQYFCuaSbTxxN/lSnY5OsvVhPdL3PBLp8nJRL/9Gm3AJ1B++qob1TA+gmwOiK/9i98A4Z422aFkdVw+ulqgEN8WyqWFTIheovI4eefVByvBCW6NU0D1wbSiCUrJzN1hlbzEy2kcRFJSQMI9SvZJZuvZL6lHx/9i8GHjka9xyLiZzLIG8yTn7lOLo6GhcvzBNhNyUjVxK6SjMbyR4tJNzasG6ZRo7sQN+rfTV3AmwB/1MQDaXKTk/ewJZ4vigh1iLrUMawEfpOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlDDiVmnXybg9C6T86G1EMm5/WFg5HjeAb+PKnAjEKE=;
 b=KGW/jD2iwjG0xHAhtP05/nMNBWMuOr40zCNxTz/QrLXVnyJYB6M+h4Y9MhTB7ORAan9HIwBrqvMhPQmaErriCMiJrfMO8//FwwOYlsKLuX3dNecALFe0c+6DmCob2Djt4gJSKTb2nwXziIeLyc+XyowSXhefLshKtdV/QC608qI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH7PR10MB5721.namprd10.prod.outlook.com
 (2603:10b6:510:130::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21; Thu, 11 Aug
 2022 10:15:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 10:15:25 +0000
Date:   Thu, 11 Aug 2022 13:15:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 1/4] vdpa: Add suspend operation
Message-ID: <20220811101507.GU3460@kadam>
References: <20220810171512.2343333-1-eperezma@redhat.com>
 <20220810171512.2343333-2-eperezma@redhat.com>
 <20220811042717-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220811042717-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0099.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e1df1db-4d01-4b7d-0a46-08da7b82683f
X-MS-TrafficTypeDiagnostic: PH7PR10MB5721:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tlHOA641WP3M8+TeMtUBVR329GZ6H7sXuQgaq6OBPu1s4NGv2lt8ET72P8ZGxeZqKvHBknmQ4iTTZQonBz+ks4dtwHIk6UIUyxVRy+I7qLd43z+fUg8LkcfDe+BHz5qv1m3yuqqkdlo41cNV0w43EUII8Y/kS2+ICXGMh+8qQCQUpZxGL/RIX/f06Oe6nclrStcNO4WN43XNLV5s4KviE5TpW8dtr+3kZQFeaoaE3y0JzWb72LkoXO8g/h7EqkHQXyvgenwEFLf379OYKicHsxyTIQccY1wan/uDF5ZiJoAWe8mzWJKgyCdjiH0xlmnOTGVlmZdE0jqxlIXBjn/jzqgl9J+C/xolD01a/GcE3cjG6CDaP7VR51opKkk4cZhf4SEM9uhhrYiwTPqJyONBUdMDbJcJm9ANXti8DwLeV4u7jLMOQJ1gne0ZVWTBaUOeT45euhUFmEKiOPJz4PRL1I+ZRMaSblYMG3zQ0FrSDmHJeZcTDBKNXMFzlVT9/HzkgmM1P5KHPysdT76CucOiNAY9GMZ/f+4lrADm7uV41n7JF6FInMTvoGdCcBt2koVG7KHd2M+vDK1cqphjBdZ78UuKrF8Y29MHvK4YiH8+YRRgn4gayHQV1QzREIsOqTcJzix6L6NNNlw+m/wn+brLz74/7WvdPn7GFNV7rpl2W5GGPdg6E23q26M073w6Cd26xTAPoSJ1yTjXo2P5azbYJV418ey83o0yP3Q/4BCGxpQAEa5xBfgib4oKrRrqsiXXAUnzCK9AbePRNWHMlZXQQRAHigKpP5+APhukmDdyGaqT7+tUY4ZEDYu/5uLJMYIp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(136003)(396003)(366004)(346002)(39860400002)(66476007)(8676002)(66946007)(5660300002)(1076003)(66556008)(4326008)(7416002)(478600001)(186003)(8936002)(33716001)(52116002)(38100700002)(86362001)(33656002)(6486002)(44832011)(26005)(6916009)(54906003)(316002)(9686003)(6666004)(41300700001)(38350700002)(6512007)(15650500001)(83380400001)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?w0n1aQFcmVIMxyFKvTfCzxIJ31QWmfFKsi+mDFmin2cAq/TlUWAfgL4Zao?=
 =?iso-8859-1?Q?+u5XGlHt1lpzoXEYf9ffh7G+mPZhtvtMBIpJkOpbBhNrxpx10cY9Aoj0C4?=
 =?iso-8859-1?Q?56WUa1RhssSBdhjHSYU9m3IUAEi3GwpyRgAXoCRD4K2W29u+VkH/2idkv1?=
 =?iso-8859-1?Q?ojTlsltMqo5yJYQ7QBTXGRK5IxHoh+VHQQRZrYj6XPg5PJiydQdu7wS2cb?=
 =?iso-8859-1?Q?ZrREi9xZ4Fp0U6ZD347c7oo+WfW35DLXK/UT29FCVLuXsShb7Z0WAvPTSZ?=
 =?iso-8859-1?Q?ra1v8F0N2POa/QHcdf09Xdj97AFq+3DSSUzFbP8OnquqzvJMzAzLDgHMUK?=
 =?iso-8859-1?Q?Km4vPXvTz8PWUY2A1j0co8svpla4BG33/FvE2ik/wiZZctMi/SgZsRI5eW?=
 =?iso-8859-1?Q?US6JZdFxyMzN9N3ESj9xqQU31xlE4ohst6iCdu2x7VEVkS7KNnVoWtGplR?=
 =?iso-8859-1?Q?62zvt608he4nK0jAy+15S56KQqn05QKAipf78IXh33NcgWz6p3SY5n96AW?=
 =?iso-8859-1?Q?w8pZsCA42Mbg3h971YZM+hOPh4YVBz756bCaD575vB0u0PUhhHgfE0M41z?=
 =?iso-8859-1?Q?bkiwcKgUO43xLIEcC61JnslaXQxMOLLkAfRAwFtmSqcoWqlWYAv5fZX1Hw?=
 =?iso-8859-1?Q?/arE8ejW8cR9yS/RDLAYe3ECdG/s9sGsZxYi/+EEk44qWnYyvKZI02BQwM?=
 =?iso-8859-1?Q?3PpXtU1jwcTh/Imkdw4COh/0RusrU4Fy3bSa6VE/zqImnCfWlnv7e61xCf?=
 =?iso-8859-1?Q?WuM/H0AltbPWvjytTwsy0B3+S+VFINLcpSAi98FA1Ht0TN8o3u+9lVrPot?=
 =?iso-8859-1?Q?OvObkrwVuriYWzJSrV8YRUZUg7GXL65YoH7wjFUYnA143N/C9tYD58i37W?=
 =?iso-8859-1?Q?VHo1fZtjFUsr0JeqY/IoPy3k1mN1jtFxtOEi3zhOa6XoRY9a/2EIV1PvCO?=
 =?iso-8859-1?Q?sl0JqOMTpfWorSVpxbIt9EisA1m9VHDiRzITAsQ20O0gRo0iqsJ8VdzfrI?=
 =?iso-8859-1?Q?SnnYnlcjvdewt5rmpijJQamgMsyJEH8TVObxzGUcSbyKGt8ekb4yDpyFcF?=
 =?iso-8859-1?Q?7sHbDsQwMYSc6/Ftx+swHiB8OwnecfbxROfltR/wJFkJd8ylAU4eRq9Rrh?=
 =?iso-8859-1?Q?vX3A9BpyzIsLpLsX8VFSQWNBFREuzpwuCmvmP1E7l0RsJBfi0mbRU856/N?=
 =?iso-8859-1?Q?GufYg1BFxBN0gZcPBdO3Uq0KpZXKyEqFkvi8AKPJuFiIpzy7XeLeTPrL3V?=
 =?iso-8859-1?Q?uYXRIRyC/3aIUQsWrYhq9Q6gdilZOWV94CRULKhL2lLYGwI4YsNbY2jBm8?=
 =?iso-8859-1?Q?cGEUwQo0vWaLvfoVIuWRmJZQUh5PWqeqQSLjDeAjpWd6Xg74ug0dfDTIlL?=
 =?iso-8859-1?Q?9kYNDLL2cqDhxmY28SK4oX7L1rVbnj9XGb1x345vWohcN5986hTqzTxFPt?=
 =?iso-8859-1?Q?nJneKQp7IcP98NGDQfsdmYbS8EdTf3AsYsKekFxD4o1IFXdhCGomP5NccY?=
 =?iso-8859-1?Q?SNHjZaT1BauaROiVc/XglJEWN9kb+X5JQOs0NUb8cV8Cx/6oilAqLgBlRM?=
 =?iso-8859-1?Q?kmRqF5/nXZvNp2J0koFVt6fSiyW1mAdBO6rsILEFDhi8LPC/bdvlsj/UrL?=
 =?iso-8859-1?Q?lhFzhsdvV5d88h2E9WVYP/fIcnCpqRirIa3HSI6HEAl/APDk7AtBY4ag?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1df1db-4d01-4b7d-0a46-08da7b82683f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 10:15:25.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: js4AmwZGWcF1dgDJVIrMh2/+LFuijbSwGp3Sb4eueGPd6L7FkhmxIiba0nQP4DOOP671Y+5M74aYed90oLcrw09/TMWch+KXNnwz04jW1TY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_05,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110029
X-Proofpoint-ORIG-GUID: ke2nGLweUi8c1CK1sobUhNj2eJ-T6F5N
X-Proofpoint-GUID: ke2nGLweUi8c1CK1sobUhNj2eJ-T6F5N
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 04:27:32AM -0400, Michael S. Tsirkin wrote:
> On Wed, Aug 10, 2022 at 07:15:09PM +0200, Eugenio Pérez wrote:
> > This operation is optional: It it's not implemented, backend feature bit
> > will not be exposed.
> > 
> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> What is this message id doing here?
> 

I like the Message-Id tag.  It means you can `b4 mbox <mesg-id>` and get
the thread.

Linus has complained (rough remembering) that everyone is using the
Link: tag for links to the patch itself.  It's supposed to be for Links
to bugzilla or to the spec or whatever.  Extra information, too much to
put in the commit message.  Now the Link tag is useless because it either
points to the patch or to a bugzilla.  Depend on what you want it to do,
it *always* points to the opposite thing.

But I can't remember what people settled on as the alternative to use
to link to lore...

In theory, we should be able to figure out the link to lore automatically
and there have been a couple projects which tried to do this but they
can't make it work 100%.  Maintainers massage and reformat the patches
too much before applying them.

regards,
dan carpenter

