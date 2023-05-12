Return-Path: <netdev+bounces-2176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8840700A31
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C36281B7B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961721EA67;
	Fri, 12 May 2023 14:20:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A7BE4E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:20:40 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8A42681;
	Fri, 12 May 2023 07:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683901239; x=1715437239;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QZH4gfC+cJfW1sueDY1bjWs1ku3z29RXWX/9qU5KVvw=;
  b=ZCPTo04s1bcC8abpwxqctFGbhnb9Y6hmutLAp4z082vdJULlgMdtBkNo
   SobweWUsdl5FQ4vDagBFv5ceQrOo2qKFRyVFrRYyfQ9BPN7FrIGGyDNBI
   NtnhvGs0cUsxkbqDTkgkun6A2btJnfIkgiGRB86BLnGsYmvkzrrL5QCKd
   bIEcnEV1MlSBNWzXW6BnK4eYf5Az3CB4WdsUyXtPMwUaDOj+O1Fc2/v50
   BZ8TYog8/Zgt+nlk2VtJfIBB6JL3H/Z4qK8bYAfSfmI0xccWPEPcuk+Uv
   NP2wbImgwUQslMWWo4KoyWM5VuK1qyXUVWzPZfZv1E42aW0c1t9ffTGop
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="340113272"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="340113272"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 07:20:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="733063545"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="733063545"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 12 May 2023 07:20:38 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 07:20:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 07:20:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 07:20:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvHdYpAJkky5LfG0y96PT3oMtrq905e0QagpZZkAhaETR2sk0kD/uwT9bHIyf7hlKNDjyG3SXxiox4Fbbde217TFGpVqT0fPH3WPFrRvSu5FoXcTaWiYZcpB1T7zk2tFU99CaChgp67IVjZk3LFBEMfXVN7/BeEhzYG10Nr7ydzAvtNJYsrAdKAk+bX4wEFaH60Va00ydhoK1PhmyAlGHSBouPbKdeqXFpfmyoUUhydmu7pWGIBuKgrtsDtn1B8P2naGFyAVh7nqUQhjF55toqIjqli7V/cgCiSd1N0eqbCOaSHDt/1T9GU95bah59Lokr/MPNLs9KaN4ew6HfnswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuEzK5NWXGXhERQ22UVq8ELy58R6faNZM8dGPLlGPo0=;
 b=Gpci2i6AP+SznR69uQzECRffO6Zt+Y/VwxKeqysFY2VrS+qV4rLPK6EuaQ0FqxqeeY3UPOqCKwNvmZOUV6QFPpZEnep9KKrtvUYofAGtbZhiZHwWUuR364Oumoq3+cBu6CepunCyTXlodhnyuRU+uiXLy2qYRoyh/IuLhN16zZj2rHhan8tPt3BwA2rBJFhaNIjM2st0x8faGNM/oCxtw3oHYmDhoeBOqayeMYpz9SCY/FXwYpWRhA6tsD7kmnEMhHZPfHgbcjO5eY2oMxGJqx2DLNzaV8em/tOQgtYPwDs3ojkFU7PElxhmeu4ZHVK2QG8AF7aqyJDBnzfDG08F8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH0PR11MB4917.namprd11.prod.outlook.com (2603:10b6:510:32::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 14:20:36 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 14:20:36 +0000
Date: Fri, 12 May 2023 16:20:15 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: "alexis.lothore@bootlin.com" <alexis.lothore@bootlin.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.petazzoni@bootlin.com"
	<thomas.petazzoni@bootlin.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "miquel.raynal@bootlin.com"
	<miquel.raynal@bootlin.com>, "milan.stevanovic@se.com"
	<milan.stevanovic@se.com>, "jimmy.lalande@se.com" <jimmy.lalande@se.com>,
	"pascal.eberhard@se.com" <pascal.eberhard@se.com>
Subject: Re: [PATCH net v3 1/3] net: dsa: rzn1-a5psw: enable management
 frames for CPU port
Message-ID: <ZF5LH91XDIh9ArfG@nimitz>
References: <20230512072712.82694-1-alexis.lothore@bootlin.com>
 <20230512072712.82694-2-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512072712.82694-2-alexis.lothore@bootlin.com>
X-ClientProxiedBy: LO4P265CA0161.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::8) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH0PR11MB4917:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f046833-2c82-4e9a-c9ee-08db52f40d9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zkkw3AeblKn0u+LykrgiL3KiWVTYVoUFs/o/kon7vunhtN5NAcm/f0MF6W0meFaS0MYbgHZj7SLBTFDbpkVmVTrPxLTXMbGDHsli0ZY7ZfQqvV4glsIP70uRzRa5uuPWPwqRs68TY5oViLEX8eEJSxSx7g99KNarjlNgr5u6de+4uRBumIz9Ae8EtGAA1HSjDaNjgst+uM4AT72L0EZahoPJVaVSzwKEgw4QeRIh5ktMKeB7MCWb7W1yBfbaNfQUlP5/75WgE4msuPcvK0XYF7DyCbhO82eiT5qUo+XZn36/34Jqh4T4cHZ8fr28W02IPUwgzjfpIRwguC0LtLMYEtlBlzT1MP2vGwIhgrSv0AZRkEJ3FG7FMXwQevJmB1+a1Vklf4AX6Hfhwhi0LEM/FBic7Dg3APy17B1EZk6I9A/awNvQOOv5tUgOZcIyawOV0z7U/s9wX5zmjTfLu6vHyq40jQfn0jTz/HKmuH5CYfoyKu1Hl+WziwJvKeUI1MKZxgqMKYNoBC9HOfMJS0NTOLEtBgWPqpq3BWUcPEyeDB96Tb0yMWBXwOlqAi31RCQb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199021)(66574015)(186003)(2906002)(83380400001)(4744005)(33716001)(38100700002)(86362001)(82960400001)(8936002)(8676002)(6486002)(316002)(6666004)(41300700001)(44832011)(7416002)(5660300002)(478600001)(54906003)(66556008)(66946007)(66476007)(4326008)(6916009)(6512007)(9686003)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+4bkuwDWUqrRziSjqBM2PSFvNWDTWONBY11aPhBfpIMG4umBcWaNa9L3Fe?=
 =?iso-8859-1?Q?8mxofxBpA3udk2Pb4FwbxfQg3F0tPR7OgGkXbFabW6RFPMMExt5tg6xdnH?=
 =?iso-8859-1?Q?Og9LKPkJhEjbGgvh5FECPBXBWd8jQiM3+PVjN/snVNvpIvX8OfPVbdBCOv?=
 =?iso-8859-1?Q?fmt9M0pSpDsnf14DflzcZi+VGEw7X1jJ5eqB6ddp+cSK/q7i3ffdnxvlQp?=
 =?iso-8859-1?Q?Fxu9ZxqBwDGZw2H5qJeUcUiV8looihjvW8rYdq4wXKGQZxxHOGYZqaNw8Z?=
 =?iso-8859-1?Q?jKavx3i1m7ZDMZCfVj9GkIF5kq0Fj777rrejlrefG8elsSQM9iuMZv8DwH?=
 =?iso-8859-1?Q?97Wbkj+Xp5cPoUE7E39cNAixnCnQfCg/18Q8nHU9dakaml3uDwAeeaj2mB?=
 =?iso-8859-1?Q?dFmwbnJV5GO3LYPsHOPG+rRE4vU5LIDnpx564OyDuvLT9aSYaq50/02kgh?=
 =?iso-8859-1?Q?OQxYlD0d11Zy9k7ThoqN8k89GfKf6jDPPXyywF0D8d8s88XkEIkL4FgIp8?=
 =?iso-8859-1?Q?9PBM+Doa3RCc3tuiaK0+vwLfVi7Csqj/yX9DxeKgU7dt+l0w8d4oXlcjin?=
 =?iso-8859-1?Q?d+Gr4bY9YXmlNiyt/ay6srjNbqSvOvWMqCd8xvuUa2kG9yoOAztBiqt7NW?=
 =?iso-8859-1?Q?d9d6dggnrvEoIZEiKwwAnuh//e94liTwQqb/qQpB7c8/MDM9nzLwc3P6zi?=
 =?iso-8859-1?Q?f07kXLCS1m0dF/aOPIYhmwm5RST1tR5IwhSZ/BQ+WgyWLJ6Ui3LEON48AZ?=
 =?iso-8859-1?Q?rQMJ/wCTxrFm8qv1O2/XbC7GjSoFZZGfcn8lXtviTnCwROLj+eFj3i9NXa?=
 =?iso-8859-1?Q?30UfjehEl8H/qgXyXD4rzjMR10N1AeSqF+VKc0WE9spLULNvEHtF7Q41EY?=
 =?iso-8859-1?Q?8MhHboipJCwkw2nAlqgycdz7IvmixPalvHWmAUIyWlVvP6DdwFZWUoasYt?=
 =?iso-8859-1?Q?x+zTLmeYnClAuOQ7ND2qhLQ5axdmIOWJhgel37uHx49A3ufwmpcD/y9Lyy?=
 =?iso-8859-1?Q?kNSxNrv6CcQfiN3BNkxOFLzPiFti+PL99DejxjpA/TnCKBG1Gu/S/UulhQ?=
 =?iso-8859-1?Q?E7HyrE258NC9/Iu2vCbb5tm/vVAZ0mXCD7wDSkyVooEnLWBY3KR6SCaSCw?=
 =?iso-8859-1?Q?A8KBGAaXfnhZDwT7t5rQnhM1CG2bDwbZ/4HfhaK/kwJPivoRZRDKfDSDr+?=
 =?iso-8859-1?Q?xFoFJCg+Dux8Nl1/sxGAcf5jJJbR38RmcgnM+pBXGP5qEW1R9UNGePFQGR?=
 =?iso-8859-1?Q?O1lQP+KaCiIpDNgvmxFhT5aHv1mBaeEEXgzY8NWATUTn8NkfhUFWDGuOyY?=
 =?iso-8859-1?Q?Ggb1MMfaTe2HmY7/zkB1ylzl04tFpIr1cuWlzxd4figGn6xejb0oeKMIpe?=
 =?iso-8859-1?Q?9kZDQX1VtoE/b5rwGn/cqIGEjo25fzEPyPWXGFC0ADe9lnQd+605zGejZA?=
 =?iso-8859-1?Q?d9vnPw3HrqUMswqpQ02jnwMqDGTSyZBCzLTpLCknn1bDccoVfrlAGIvfUn?=
 =?iso-8859-1?Q?hnFqF9Tms+i94eK9+8gkBTmgihz82a6OMVZJUa/39X4JJ+EMHJqqyGJMxb?=
 =?iso-8859-1?Q?AFPj4UHk3biidzJ58GjCrwk7Mqso5lupaqxKoNiqMvtj3Oir+s1FKkBNid?=
 =?iso-8859-1?Q?6r6O61QXNv9l89UKnwURlJhD+JvwZOqfR7rHMZIBn94UDfdC6sZjKZEg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f046833-2c82-4e9a-c9ee-08db52f40d9b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 14:20:35.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zR7fbpAAhOJc9STJfSNNJlBB6bjJz5AD860EjY04aXtM9P/jknHjrkXj7ILIV7VY/o01L2F8883Tz0J71hCStlm3L8KlsktlZnYFUJGJBdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4917
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 09:27:10AM +0200, alexis.lothore@bootlin.com wrote:
> From: Clément Léger <clement.leger@bootlin.com>
> 
> Currently, management frame were discarded before reaching the CPU port due
> to a misconfiguration of the MGMT_CONFIG register. Enable them by setting
> the correct value in this register in order to correctly receive management
> frame and handle STP.
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> ---
> Changes since v2:
> - move A5PSW_MGMT_CFG_ENABLE definition in this commit
> ---
Looks OK, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

