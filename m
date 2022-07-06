Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8A56890C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiGFNKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiGFNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:10:05 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4C42019D
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 06:10:01 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266B50r0030442;
        Wed, 6 Jul 2022 06:09:58 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h4yvr28vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:09:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5gsHAQndQcwSox221ujSCvnfGrkST7DrJolZmKPrL8X2+fa4mfDrjFGXGRHTdI0GVTpRGbqaqtW4rI7n3MA2A72XzHIO57gQ8/2wKS7kUaoW3XsJOSE+riU7mEV/ce80ORukjio7JYDM9QE4XCiMzLXumPMftyRTqta0Kx3bLr2sc6S/YwXiWnvI1jxJ3AyvL/Pf5N0rRtXznE/cE4A5SMlaGHcNhpIzJ8QtEeuwVypnGfZgFbow3h090riRsLzRBicSSO/scsmb1+IMK3XPf0vEEdFt7+C7n7xrp2f/Xgxb57s4X2M6DG+uF+5QNgParGTlBh/9nz+oX/pyavGIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYWfzWy/TB5F73ONxjQ2PUpMW2qzK9e24emtyZ5beqc=;
 b=SL/2rcLTf/B0ZgxOpHs8zSnnHJ9VQUJgujaQYC7s9jfE2SNxNNLXRVoIbo1oKvotZhRCrzFvcpuWzEQi6LpyGpRBJWPBbJQqAFzDaFyuP1tlMjBu77rlizjPQmkT8hcbDrekAEkV7EKclqOaVQRGvWDM0MO+d1xWF3YOKxcMFXTEuwFPc8e4G5oW73QugvHruztJQlfLtrp84iG5aMbyTQF3s9ZDKEUBiItc/7Asuln2pzUcmjKNYW7AiQPEsMWm/ewTNfcb10PIg8TSErwa7JsIAx75VZ9I/weXJSe3F/ywXrwxe5NUWwiOw6f778Wk89941PNMDWYUF0o78PjyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYWfzWy/TB5F73ONxjQ2PUpMW2qzK9e24emtyZ5beqc=;
 b=hK55+H9CeZ3Gz2loYk+VEfwqxBssTGkxJB8Q4gyeemJg1uA/OuL1uGPTtovVCMKOj1spqq1kR8FW3Kr/Y5R2wHuv1oqVk2gfHqwnbbysGRoFR3aT7vgP3fpaoLKAkJoCdYH0Eda9o3kZVr6sHF+q3lKTz45FgqDEsFx1/PToDH8=
Received: from CY4PR1801MB1911.namprd18.prod.outlook.com
 (2603:10b6:910:7b::20) by SA1PR18MB4774.namprd18.prod.outlook.com
 (2603:10b6:806:1dd::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 13:09:56 +0000
Received: from CY4PR1801MB1911.namprd18.prod.outlook.com
 ([fe80::cdd2:82:892c:8b3d]) by CY4PR1801MB1911.namprd18.prod.outlook.com
 ([fe80::cdd2:82:892c:8b3d%2]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 13:09:56 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     kernel test robot <lkp@intel.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [net-next:master 5/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no
 previous prototype for 'rvu_exact_calculate_hash'
Thread-Topic: [EXT] [net-next:master 5/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no
 previous prototype for 'rvu_exact_calculate_hash'
Thread-Index: AQHYkSEn+/xh8oeJiEiu/LnZzMjBMa1xUOcg
Date:   Wed, 6 Jul 2022 13:09:55 +0000
Message-ID: <CY4PR1801MB1911AE4364DB46AD0DE84046D3809@CY4PR1801MB1911.namprd18.prod.outlook.com>
References: <202207061806.PD7mLTe7-lkp@intel.com>
In-Reply-To: <202207061806.PD7mLTe7-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74f6fcef-ac5a-447e-fe0c-08da5f50d285
x-ms-traffictypediagnostic: SA1PR18MB4774:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QwKYw1zNxPJpZMoaHwX/H5vPkWWACZsu+jy6aUaluKdqrXyvOifetYtP6Ih7P81txGiud19GNjLX4yLimee9z2DR/Nya0NMpzIREdOFq4lCSBBLHYvWapG/dNt4JOGpXvAItWNJK4g+NSW4mmPM8zXY71RfqIEbutrSytdjami3Y6pBZkeHJblrIcdIWOE5RVcg9Zu7GKetcp+srUwGgFe4/gNcPzWoCca7AV8k5m3bHWZOn3cFfOEjliOE87lvAfxD5MKn2e9nxlBJpgM1zJq5VbxVBK3ZiEWH6HLzTvPC4lFvxJ3Ru7wVGz4klLjYSOpO+n+/uIcQWVrMK0xbrwiYW+1o1e23pxvW84a/2XKOq2vKFrJXFvJO1JQi4dtxKYPSPN4BZrzjlrRFdoCzoAHAUf41MNGHEgjK/nxwWh0v1s12NdMC/OkGP9in7NhNizfM55enRGRM+VCMQrfPdYTND2x+HPGrBGegx3aTD+0BJeIGCzDWTtvRoRs3jg8UrMQtKaEDd3A6Lwu1MFgHbbOHRG7Jx69UFPzXdYFyrllHeMhlQL0uPtHD7iC8I5wg20ueUSI1qQhO3Bwa1Cdqg1CLFm5A1iYqAa8C6io6QEG9FHqYEqI/DmQEx2+vbuY7OG+EBOQ0XAW2MiP58IGdRb0yVEmOAjgjok9uZZy5QT+Am3nr296Cu3y91DOzQWy+R6P1DIgfCmUVsASZftL/uDh4Eg4TzvjdxjLKRkX9CjeIJHx5KeE9lppt3hfVQzucmEPWeUS9qBMIwcQH02Ja/4krQ4RHx1SQKyEb1wNm2vdoNU9SohVy1AFBsR8OEC/Ikmv5u79eTcqUJdlrvSlMQmRCFpk5xtZ4NzW1CHyMVCTw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1911.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(8936002)(966005)(86362001)(478600001)(52536014)(5660300002)(83380400001)(4744005)(186003)(6916009)(316002)(55016003)(54906003)(9686003)(38070700005)(2906002)(26005)(6506007)(38100700002)(122000001)(41300700001)(53546011)(66946007)(76116006)(4326008)(8676002)(7696005)(66446008)(66556008)(66476007)(64756008)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v496NYNMpS0JX8mfkrp6yzCs7P21rOfzgrCsAEEj7v8bhG7PQD8eo78mIEeu?=
 =?us-ascii?Q?jQxeHQe61aBGKyxd0AirwU5t8CBov4HczrS2qJu1oD2h9h8XVQ9COSdDJbPT?=
 =?us-ascii?Q?sUpAuzE+D1lZDb4h1NBuL6hYIQXA/pjqbvL5Jb3rFID8C4YIDbKkeOAaIjeH?=
 =?us-ascii?Q?2DgqgWpOaJqqIhpQbXWeFSE4qNU1hlP5SKh42eR0LAdyZk3GtUurxPesLwrL?=
 =?us-ascii?Q?jpQHs7y5b9bdpMIzzHof4jGtXgWJf8mgK3kztoFvkJBHSFvW/QnxOMPCAAS+?=
 =?us-ascii?Q?q4MVpbzUmssXa0ZCP9HAM4IxXZ9ZgwRvFWoG7kmvP/0AuWouwDAGHy9sn+eX?=
 =?us-ascii?Q?Yo1esSJxbc1FX9sEhqs4xSp8tUF4esGpQzpIeEYMgob70M0HgItL2+7LOW1y?=
 =?us-ascii?Q?G/gjbhFp79OBY0SGRhg32MtXAlD8D5J9D2PupssCbkahsEmhWkXfCkwA7m5A?=
 =?us-ascii?Q?MoGPRX0WwnVE5waAMasa7kscCJICzAcbxk/BXGLEuZJzbDlvBwweGhIXGD6n?=
 =?us-ascii?Q?+z84Y3jyFjxzZamYjTA4xosUXRSSSA3NqteNz+4DBbfnmgc0QxYTz4QqhcJu?=
 =?us-ascii?Q?4QIoFlh+pj9CPwkUqlNz9mGZ1E4mGVlim7VG/KnusYP9XZntmQSBxVxO8QfB?=
 =?us-ascii?Q?CgyOAoIHNQfQFMnUu8Lhy0JM5rYTCrCA9QK6SsxjrpAE4Droq+JhLTVNyWlF?=
 =?us-ascii?Q?/WGELyXlu0eH+b5jGOlsZ0KpjUFAmFWMpcuPhY/HQqS1W3VzDc3ihfm29xZM?=
 =?us-ascii?Q?nB28IQyvWuZon79pdN89fM9oyvZHDQRB58yKarQqa1yXD0zeZU7KG2lOEztt?=
 =?us-ascii?Q?hkjW+3P5pDEGeYHv37Uj3983anjavNkEL0Ou2sBTiP9CAi2CNRXmQxHvs94N?=
 =?us-ascii?Q?4QWN1VxNIPo82ymprWXYIBtmEGbn+u+hHaNBk6EnmtocPX0NCJLc9ew5Hno4?=
 =?us-ascii?Q?5J1DMqlxNUPVnEtFu833XDBYiPO7+JAOc4S+ue10ciiipikuqjU9psJTffLX?=
 =?us-ascii?Q?seVDMp6x+eEJLGvWwmkyrQU0FWjp5p3IrflqdraNy6yYLUVVQDY+1mkVPBSz?=
 =?us-ascii?Q?2wtBO8Gf/DEW/2bGdTY5iUJxoXViM1/LIXkoj+D/u5VGZW/SI3yMTxF3HvTE?=
 =?us-ascii?Q?Dn+OdkXVp8ltQAMu/rAEiWvmDyE3V8tcrDp+s2sGNOtEla4KYXj83g9j4jox?=
 =?us-ascii?Q?RRRWPS0vkP0Vihxk6j0r5ADiWcJgiz8KSkBqhH4OAyK+ps7AhatYlR8SX9B9?=
 =?us-ascii?Q?TVbQmfDfsdGfigEAkFANdhqycxNIqMnLs3AacF2npTE3oiuVNc51cQEc4bAU?=
 =?us-ascii?Q?2thLuS3VkqQfMk7208d/vaw7tCMrURiEpclAVTIB7cU6msJJ+DvQ2CMwoNBa?=
 =?us-ascii?Q?u1BFmhQMvqIhTbodFBLxtpDDy5ueVljZLGbnxS03aszo8ISqXkBrDrF69MI+?=
 =?us-ascii?Q?/h3mutrWopGRQUCQgcWTW1q7Ws6JtBumPSN8e4xKP7FN2+DumXsKpwDCvLWn?=
 =?us-ascii?Q?JDRgR0WFxSqb/2WHrxQb3E3uJbgB+1n55TAn0ojBU6y/kIfF0hgMOI1JwSr5?=
 =?us-ascii?Q?GPfN0M/zaHLLYEsRPLooPUAPoAB9uuvXyQfCLF/b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1911.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f6fcef-ac5a-447e-fe0c-08da5f50d285
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 13:09:55.9740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZSeuAX9u2FI9Uga04+BRMcNRJK8TknyDbXAz6Zrg/Q7XEo2Ip+OqumvFoxgUl8Yj5y6u354VBppp9+klOE2mBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4774
X-Proofpoint-GUID: 71gOz87Njh1obAjLiLo0CdtXLt-GCACk
X-Proofpoint-ORIG-GUID: 71gOz87Njh1obAjLiLo0CdtXLt-GCACk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: kernel test robot <lkp@intel.com>=20
Sent: Wednesday, July 6, 2022 3:43 PM
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: kbuild-all@lists.01.org; netdev@vger.kernel.org
Subject: [EXT] [net-next:master 5/16] drivers/net/ethernet/marvell/octeontx=
2/af/rvu_npc_hash.c:388:5: warning: no previous prototype for 'rvu_exact_ca=
lculate_hash'

Compiler warning fixes pushed for upstream review. =20

Please review.
https://lore.kernel.org/netdev/20220706130241.2452196-1-rkannoth@marvell.co=
m/T/#u
=20
