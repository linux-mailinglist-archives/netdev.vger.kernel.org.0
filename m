Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9EB498924
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbiAXSxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:53:09 -0500
Received: from mail-mw2nam08on2104.outbound.protection.outlook.com ([40.107.101.104]:26247
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245412AbiAXSvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 13:51:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFF06zMHizJQBxiQDxkzfWxonfc5KXBAv9fY6ClWwXPePCj1L53da6r1isnrMyoqjcUl3rWJlfcD+TdF/8Dymypc4BuhzotwiRmJKpPeM7Sq64od28ECcg3/S9gu9lCi+E0fueq2IbDpiKh3HGNFL13lTZ6vvjqazEV0jwPWOthatAxx8DIFzgJ1VbodxcSQCItvt58A46veVEs7ao+nkNFUerrPEeecMUzcixxQB/STaCTiSQLJa9Xv6xVfHPc9mGTnh2D06Jx1F/V7dzGWYZVp1J47EF5U12ejEhkfFAi3+Jjb5OHQ2rW89NTdev9eo9gwJ6fsvGNJRriBrv5OrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRI5ZXI/DL+ERF9ZdhVa1jjW8ChgMqLVNm4iWJguf3E=;
 b=WmRwlvyQ6h84U9pfNj5eyj9tuq10MX4TiWe29BnroUqkfs/aGB7N6aPE+4CVCjN3tmC0NnJpjsfexQ4Cjk7nAtiYM5zM1hFjMbPXkfiPCJENjgg1y0Tw0P+08FGLzSLPZMdqzObpiw3Mv2EwCWF27o6O2zKXKaqRst7r2Mb96kRfEeBhrR1l7sAaGuHDZKxuIGhQYRZe7nnpaFlXBOtyi2fKxzPjpUefyP1hv3lvigDhkpQ5NGML6baMrDm0ocT6+P7JW2ChXOpqr5XhKyOA/2DjZ2wUE1q9dQqx/DHuHPUcjUb3GC0cAQhyVq6/cnOrj/ktcI5wkXVrByOtuBWJiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRI5ZXI/DL+ERF9ZdhVa1jjW8ChgMqLVNm4iWJguf3E=;
 b=fvDjsCzlrywEuxAK70gXb7/oACJZwpMBjI50JaWHofRG5u7z+rfQUGmOOk+KSi2Fff7uqpkHGmzOwakWoFxt4xPOQlyLtNSgZkXP+fre3EgZtOAniT8QRmqUeEYiVdK/tXYCDFqv5+0b7916l6R1rmGV4/5ZdsN7ki9UcMWTWP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB4237.namprd10.prod.outlook.com
 (2603:10b6:208:1dc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 24 Jan
 2022 18:51:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 18:51:48 +0000
Date:   Mon, 24 Jan 2022 10:51:49 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: cpsw: Properly initialise struct
 page_pool_params
Message-ID: <20220124185149.GA15153@COLIN-DESKTOP1.localdomain>
References: <20220124143531.361005-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220124143531.361005-1-toke@redhat.com>
X-ClientProxiedBy: MWHPR1401CA0002.namprd14.prod.outlook.com
 (2603:10b6:301:4b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7633bd32-3f22-4759-41aa-08d9df6a9341
X-MS-TrafficTypeDiagnostic: MN2PR10MB4237:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4237357595086A037273271FA45E9@MN2PR10MB4237.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uUcU2Cg1eYvpenmpecGvPiqrvYDYag2mck4Lgru94hkt3QQp1KfU/v/PsMqS5hdPDYssvwhYQpn0fcR/jVczsuatgBko9sDCqD0xCylhcvWeXvLptx3K8+zun6p76bV93T9MKhpDa+gFspFvxABIz0CHsJtieb9+WrhdZMJKwpzgaPtn/eb9Ih0aidmg6cihRYatKPDM2jPng1OoHH1wzEMf40SmkqwI/ntz3hoW1w7lLqAIq3LW/Im2GrZ4wGqrJ+e10HNzqtGvpiFtFqIfUeSsgTKcS6e9x9B0meLm5TC0mh1MZYGuw1RgFXRGQ7CQtL8A9MnTgy8ikN2R40z1AOVhCaCN/zVtzmRlUj3wTNZ6cL8eH9m2YPKmQOlB40KLDYQOeDlUP4Z8lQ3P8rYq4qbKM42D/dpNEgLoBTdXtCeXcIL7Ep1gT3p5ib3kNbpB3f0zI23up33MGZT16FucLpZVlFq4Cmbx1MMfq5pQDPO9fTw81QvNtsCoa0IiXueUjDC8HPzTkkE1A5+QhrILBUSkXWjirnH5vSDA12KhLGOBTsaSmA7Y4WcmYLzmktyrLKeLHitd2ERl13J23zNl6mIPjegyobgEkd5HiGdZI99+6fC3+d/B495DIEPSkcaKXeWnSrFgoJ5xQJhki9JgBKpkwmP49sOCLyRZKcc8CcKS5rMT1ghNC7CQztu891V3+zq+OESoGwJiHDree1F8CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(376002)(396003)(346002)(136003)(366004)(42606007)(6916009)(26005)(6486002)(8676002)(1076003)(7416002)(9686003)(54906003)(66574015)(2906002)(8936002)(316002)(66556008)(66946007)(5660300002)(52116002)(6506007)(4326008)(66476007)(186003)(508600001)(38100700002)(44832011)(83380400001)(38350700002)(6512007)(33656002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2tFVVMvMThySHNZaVd3OVRybS9GeVA3ekw5eFhRV1dUQXBESjJ4WUNjTGNn?=
 =?utf-8?B?bkQrY0lxVEdYVkIzeG1kN3RlV3NLTkxmelZFNnVVWDV4Wm9EUWFmRFZ2WjNu?=
 =?utf-8?B?Unh2ZFRhOHE0UEFVeGFodVl6dDYvSWVtVjIzTTZNUExPUm5qejB0WjNCbWpl?=
 =?utf-8?B?M3grYVNSWkM5QlZ0ODcxMHBETW0wTWFxc1Q4bk80UkFMSjQwOTVwdUhvVlph?=
 =?utf-8?B?UVhQWGRoUlFaM0lCY0JrZWFTdXB5dGtWek4rNVl5ZFppaUJqOXJXc3cwUkVT?=
 =?utf-8?B?QnBzd01lM3N1T2xzQXhOTTBVd1JpUWVXZ3BaZ0NUaHRVUmY1Ty9QSHhZN3hE?=
 =?utf-8?B?VnhEZFgvUjJqQytXbEE1N0U2UjltdC93cmlEZy9ueSs4MEUvcTJwYnpMMnhC?=
 =?utf-8?B?QUw2ZlFGU0ZQVnBmVTIvS2tFVUNDMjhsTnI5Qjcra1p6UXhZUzVJcGtycjNp?=
 =?utf-8?B?Q1gxalBOY1d4Q2p6VU1HWk5qV3p6MkxOWXNPQlRWMlYxNnRzZ1I4TlQ4cEZ1?=
 =?utf-8?B?ZXArTHhFdUt3bEc4SFJGdStrc0ErSGkxdWtNM0FhcGt4K25zbGYxUXVaSEoy?=
 =?utf-8?B?ZEQzeEtXR2x3MEhSTnNWYnRRU0dRTEM2Qmp6VGllQnB4ZnpwWGJEZ2FRcitp?=
 =?utf-8?B?THQ1c1g0dk1IRERUT0w3OEx4aXN5bjVzMDRyeC94aFppUFNjLzUrcXQ1YlR3?=
 =?utf-8?B?MEZFMG14d3dHeEdNU0dwS0o5dDRTUm41QzNSaHcyTVRtS2g2TUJSSWN2YWp1?=
 =?utf-8?B?bnBEcnVramt0V0U5aGdWWWc1VkVuQU4rTWhwMURSdlZXWWYwT3RkN1VuQlZt?=
 =?utf-8?B?VjJuNEZieDlKNlVhWmd2bzArS3VYUlpPOVhVWFQ4Zko1RkRIOTh2L1lNRFpL?=
 =?utf-8?B?QWEwZFhsdlByNG0yUWdzVjNjSG5hdjVQcHN6aXZjL0RFVSsvMm40NUJ3eTBZ?=
 =?utf-8?B?cTZuSkp6Z1FXbWdrem9UbjcxMnhab1NuUk1RQmt6SEN4TjNYcWsvNnVBVHJ6?=
 =?utf-8?B?VXVZRmJrTWJBNk0wSVJzYlM0R3d6c1ZTY1Erek42c1V1YnAwOVlOMS9iaTlt?=
 =?utf-8?B?T3BreHZGcGtpY0FJNk1oYXdTUHBwZElLdDdZV0h4ZzJ4V3pnblVUS3BPM2Ur?=
 =?utf-8?B?MmdNbjhLa0J3cGhvbXo5TnpHcDNQelZMNGZrNGZrSko2RE0vcnk2eG5xSytv?=
 =?utf-8?B?cUhMdFhZL21wVEJma0FPYlhtcWZlMFRZSGNySFVBQmlJdlV4bnkzaENrUW80?=
 =?utf-8?B?blJaU2ZpSGl1SDhxZmM3WW1hSVkzYmNMcFl6N0ltTWJLYytHNlpibmxBYWhP?=
 =?utf-8?B?QkNCVE16S3lOekM0OFZtU2VEQitIbnE4SGtkMVdHa2JhUlA1ak9VL0JEdjhD?=
 =?utf-8?B?NzZPTnZJaHArS01iNFNJNk5Wb2RWOHQ4NTB6emd5OGhOM2FBamZINUV3b1Z2?=
 =?utf-8?B?eHF4ZlpWWUlTUWE5M3l2SFoyNm90SlVsUzdhRVNOOHNVTjUzRkFVTUJFejZk?=
 =?utf-8?B?YzR5Zlg3NCtwWjJUUnJWdHpleTEycUJ2amtVR0xFT2VpUzBMV1V5VmxNQm1W?=
 =?utf-8?B?UEltSHBuNXkyMXpwZXdYUW5objg3L3BVendHOE9Udi9wY1BHOTJDZjhjUVh1?=
 =?utf-8?B?cFBxa2ViUUhaZFRHOElpaElVTmFNZFk1c2lhaTNHQ09CNTdqWDFBY0Z6c1dk?=
 =?utf-8?B?amswYjByQ0hEcWI3SDlzdzZHM2psL1BVNWZlWWZwb2RWd1JYY1p6OTdHUXlX?=
 =?utf-8?B?a0FyY29UNzgwZ0l2cnErYUt4amFINnF0Qm5HaGdSRWtLQmNKek1DUnovb1dw?=
 =?utf-8?B?bElqMm10NDZoeFRLNk1RYkorblJKci9tWEdlSytuSzlLcFhUNXNLQ093YTl6?=
 =?utf-8?B?R3VLdTNhMEVKZFVleHVRb0owTzRpUFJNQlBsOGxyTEY4aTVxMFVNOHc1STVu?=
 =?utf-8?B?b1BIRnpMcHYwbjB1VmZuaWtxSlNPTHdLVE0yNldyZ25PVisxT0I0S3ZNbzFm?=
 =?utf-8?B?d2lGZ0NXNTNzeWp1dmRBNDdzKzMzQUZHOUFhUkJRc2V4WWZmdDdZMnY5enNw?=
 =?utf-8?B?THl4eExKbzI0N2l4d2lVN2gxREg4REdKQjI3ZngzTU9KckF0MHFMUkx1akpz?=
 =?utf-8?B?OWlUbHVrZ05XcGsvdmVoaEdGY1NrN3I3U2habXBOWXBiWU5sRHY1bDRkeVM3?=
 =?utf-8?B?M3NQM21BRldVM0oxSUZQcjloWk8waDRGRkR0ZXVnSlRUdnFDRXN4SWdXQ2hh?=
 =?utf-8?B?UkViQWYrYVZ1MEI4Wjk5V2F4clVRPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7633bd32-3f22-4759-41aa-08d9df6a9341
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:51:48.2971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXE53s3YY7Lg6felQl6SHLWNq6CBlxojfpxMpK5umxMZkCWGxKBpa308Y+fe76cBZXf0QlzhtArtVWLlYDF0iU04BxCjavnznsOAZ0RZ5PE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4237
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Toke,

Thanks for looking into this. I'll this patch this evening when I have
access to hardware.

Colin Foster

On Mon, Jan 24, 2022 at 03:35:29PM +0100, Toke Høiland-Jørgensen wrote:
> The cpsw driver didn't properly initialise the struct page_pool_params
> before calling page_pool_create(), which leads to crashes after the struct
> has been expanded with new parameters.
> 
> The second Fixes tag below is where the buggy code was introduced, but
> because the code was moved around this patch will only apply on top of the
> commit in the first Fixes tag.
> 
> Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
> Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index ba220593e6db..8f6817f346ba 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1146,7 +1146,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
>  static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
>  					       int size)
>  {
> -	struct page_pool_params pp_params;
> +	struct page_pool_params pp_params = {};
>  	struct page_pool *pool;
>  
>  	pp_params.order = 0;
> -- 
> 2.34.1
> 
