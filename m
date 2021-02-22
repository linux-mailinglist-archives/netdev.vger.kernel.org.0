Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC7321A9D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhBVO4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:56:34 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:33564 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhBVO4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:56:32 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Feb 2021 09:56:32 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1614005791;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MJCxW3qNl1hPqMGc5zH16ZGY1J+V6SCxU2+Rwzu6njQ=;
  b=QSTwtmjDxI5NxRAxwSqWBi9DMLQapgx42FXIqotbwewIWkvi/hNRaGNa
   z1Wz9p4ZAJ12QW0Ur3oCqLrqlV7Ki0U3ImhTydylA0GGclNh5s+p4YZ/Z
   ZCmcmtlChxA04ZpRBjjoHVKLbwbfmo6BGkaJDl5yh7UfZ4Ir9TMl7qlu6
   Q=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: 4FTGYgDDVZVKUJiVByAJDO+Gq2ll4f3pfvbAQ5vnRiwBYIoOKobf2dCEXaGK+mCuIsvbbnw0jh
 gOfPGd9qOR+0f0FrmusWHV4F89lXZxGm4l31j4dP1u/AMBN+6lxL86wq1i/plBAHnCne7Ej3Sr
 wM7hp7+LtJBQ8V8S5RiKPie6sNmYMZ/a6pmW5lllLZi3b6bakS3pg8LiepHFqSfY4kB1iObfMW
 okuNPVnN/yDjm+rr0IGOMy1EmbCt2HXZ5e0SbMGPdPm2OIiCSZsvmuFivPVslOqHWxGFqCKU3O
 weg=
X-SBRS: 5.2
X-MesageID: 37761949
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.81,197,1610427600"; 
   d="scan'208";a="37761949"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXFgoFxid9SBdi90XzbWQoD7zc+/Z/oua60Zh0A6YTHNCQ2x19T4T/Wt8+9jSfzYjhjV59Aj5/Gq12L08nRDkZqyhORw0QyBNGJrZ/NiwvbReR4Lly7HPRPt+aZtEvgurXFsJcwaZ7AdzB//qEYCfMGnbIVLYWwbTEQQAOTKccTMBzoDeNz7hdJd4XVa9W3FTjZ3AP/2X8Fh7I18CLvJT+nf5zsZZ2kg7Rpknq5YTvgcc110WFPOBugoCcE22aAiRuaJcMR/2CKVU2A0PC1zqs1dVeRTVDocKmTX7A3ro74K1nNWs71kqIo3OkUb471LAaaZU2nw2IPK1ajBbJopfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHWIzam8C4gOjndBTLDHVX7Kab5zRN8V8acWF+pcAAs=;
 b=gIi/CBQye3wk8w2BE87B8aYZ9wpMuOuuMm2tED4AijYoGV/UzWAND7C+/md/XmESFRueKQCQg06ENEP8xDPvCutUjhGpgs8dcFOo5ZK1WMLdT6+66AmRUOaELTc/GSNtIrhets5EGItqEFQ/zqk71Kj4hBgGC1/ppB6uYXcoHZ0zfKxHQAlkqN1qqf4vIPsPHEMcz12BauywsNR7ZhLzr/XqMhHCzj+lwYLjfTjxBjULqEi2vli/CVAnyYi0TPCXAVSfDzciP/vLxEU+nIllXKeFGSLj7B7Ii3dlIl1JFZiMfPT4NgEr0HC2FE9R1JIRP5s2fAHpZGTrtXcT0k3Kjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHWIzam8C4gOjndBTLDHVX7Kab5zRN8V8acWF+pcAAs=;
 b=YbJMCD2VfUmFtIGu7o4d6nBIqnOAG/Gcmjn+6ZeUPebwLlY7+qfUb9bN9tpVUjzfZ0uvrIMQP2GzhxwAxQcBhDgkmhJshg1aGDk4ZpvCAjY873MqQi2/mFBxwZBvKHXP/3g8fNzUvfpmJfOmVFYWKZgtaiYzHUXym271a/TOHE0=
Date:   Mon, 22 Feb 2021 15:50:00 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Juergen Gross <jgross@suse.com>
CC:     <xen-devel@lists.xenproject.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH v3 5/8] xen/events: link interdomain events to associated
 xenbus device
Message-ID: <YDPEmFaWQsBhvmb0@Air-de-Roger>
References: <20210219154030.10892-1-jgross@suse.com>
 <20210219154030.10892-6-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210219154030.10892-6-jgross@suse.com>
X-ClientProxiedBy: MR2P264CA0047.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::35)
 To DS7PR03MB5608.namprd03.prod.outlook.com (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 387c4e78-c9b3-4029-2c2f-08d8d7412459
X-MS-TrafficTypeDiagnostic: DM5PR03MB3068:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3068FF543A6D78210C9E04EA8F819@DM5PR03MB3068.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Je14NHuU8TTgtU49vAC30bDxawrIvvoOhuXCa5JPGzMcNPZ6Z3VE4gcwLorgev9+wHVhGb8x45OiYfdiZI23AWAUqMEXzi9oiDtrcXeoQnV7TUK/9kbmwTOGpOum9nkDQqzPeYrrU2CtuEXrUZODzyRBdNocVaKcJCGiemolY7Mo/oHwDRiZm+r6tr5Ql2hvFlRK8t4GnRiiweoXhJMM+DSoV+0umpQxFzkfNhYbPaDYi/D9J23gHKS/xxeA1+WQirHjDqZV/iG802YIF9AvrvYfuT/Oe4PzDcblohiBA1oEBonGI8qsoecU1Wa5f67pHMFroVscrlXSWKuKu6TDprZnQU8F3ZF7XCkzXse6y89FoCmGNQlBdZ4DdRPTnqfx5A9u4LRNkORAcBGynaD6gf+rfYDq/z/nyuKvtEgtzCFYkSk5oIoGzeozjYKpceU/Z7IVTrh7roCD10VqjrvGLAxt/kSCgxKNlBTbyJBg92BCsJHiz430/0+4BxsjQgmpuqNAMr2hOrV6UZJdEkVy4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(366004)(376002)(396003)(136003)(6666004)(6496006)(7416002)(54906003)(8676002)(6486002)(8936002)(4326008)(4744005)(85182001)(6916009)(83380400001)(186003)(33716001)(66476007)(9686003)(26005)(66556008)(5660300002)(86362001)(316002)(16526019)(478600001)(66946007)(956004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2Z1VFREOEJpdEdmU3Y4SVBndTY0WU1leGVtdUxaOGN4RythVkdJMmxMM0Jm?=
 =?utf-8?B?b0dmWlo2QnRhYUkwT0FMVlpOcXN6cDl5djFFUmlpZytCMVR6QnpZZXBtQ0xT?=
 =?utf-8?B?bGsrSHZ5N2xITmlBTlkvQjFzWlRXR1grS2h1M3NqVXFLY2lPT2VvVVFaWWNl?=
 =?utf-8?B?U0J4TUFudExLOFRmNnZmWndoWlQ2czBIbXBOM1ZsRlBUV3U1RnBuUG1KcHZC?=
 =?utf-8?B?Y0llaG15MjlLZ2orUU9SMkxzc3pPV3lpSlZqM0MzR2x3T2RWb2Q2b3c1MThq?=
 =?utf-8?B?US9pUEZOSExpNnFUR2toVmtqaUlHcFdkOE9UQXlkd2E2ZTRyNEJXbERUcFRr?=
 =?utf-8?B?VzRtbHlSRVE2QVh2RlVMeWlnNWY5V1VxV3NIU2Q1WnVzZjB2WDQwQ0xQbGpy?=
 =?utf-8?B?WjIrSEQyZU9hN0ZpRzFZZXRRRUpJRldEMjhyaktScnJzdzNSa0Y5dkhVRXRS?=
 =?utf-8?B?RU5UYXg5YVZiYytNekprRGJReG5ZT1dSYTlBSTNuSEpuQ3ZwTjFYY0JLOWcx?=
 =?utf-8?B?VWRlcWc3cWJnKzRINU96MGVaYUc4b1JrUHJDQkFRRkxxRCsvUkhER3FCalpl?=
 =?utf-8?B?UVFzYkdNYURGcGJMaTU5Nyt0djJEM0drMnpWc1E3aEptZVFVL3pYakJXMzcw?=
 =?utf-8?B?b01zaE8xVWZ3M0FNM2VVNDExRWJKYjBick8raGZsczdyUHRiRXovS1FLMXl3?=
 =?utf-8?B?TElyTTgraWcxMFZDQkFWeG5zTkJ0dndYd1pNazdwci9aKzFieTVtZjRaeUJu?=
 =?utf-8?B?RXAwZDdNUEtOV00waVlldUNXUmNJcGExYTc3bFNxeUVnT2RhZjJZTGJob1dh?=
 =?utf-8?B?NkZGL1A4b1JvWFo3dE5PTjRoNFZ6Zk9aZ292bDBtSG5KM0FoUXl2SXBIY3Zm?=
 =?utf-8?B?YVh4MVVUem1RN1l0RUExM2JUYU9EczRibTVmbnhnSTdOdnhTMEVsQXptWm5Q?=
 =?utf-8?B?QnJDOXlTOE01L2FwUkRuaW50Tm8zQSthdFAvTGlVbHEzbE8zTWJoeVZjMGZx?=
 =?utf-8?B?eUFnSndQK2tEMXA3RHpKT2NZWjRoeGNEdjIydTMzUDVTTWIxc1dHNWxISTVi?=
 =?utf-8?B?dUt4aDhXTGxBUzJQUHpicjU1UzlvVUNlSHZsZHNHRzE2WTdwQ3ZQY2Exd2Rv?=
 =?utf-8?B?SjIyOVJsS0VZbHlWeDNBd3hzYXRlR0lYSkNYdXdKYkNKTHo2NnN2cCsrNEU3?=
 =?utf-8?B?MXhPL05XUnZEVDFJaTdUUEVzdURqbGRXTEtScnVrb2FrMjMyY2owcDZaZmow?=
 =?utf-8?B?ck9yNCsvQzV6YU11WG9EN2VFZFoyR1R1UVFCN1VzUVhGUFlRcW83Rm9TR1Qw?=
 =?utf-8?B?Z2tCU1k5a0RmQ2lWMzVndXlXV1RSWDdVRE9PSDRtZDZITGJaTnM4Um9qWnhR?=
 =?utf-8?B?TjFaenF3WVkwYWcrVFZ1ZGtldXg2MHB6MThsRDlib2EwTUxLa2tZaGczMTBB?=
 =?utf-8?B?cnNYbHVpamZVNzNOY1Y1VlBIVGQzMXFYRzBwVmZOZ3NpWE5vbWpFaXdqZmZj?=
 =?utf-8?B?Y0JsZnhQWkZWdU9BUWw4WVNmcWJWd3FpejNwUDY2QVI4TDBPY2lyRkZqWVFp?=
 =?utf-8?B?V3pnWUtiYVBSUDl4Mm5GMFIyNkZsMGZSejN3RmZiaUtGc2I3MVJhOTJTcHhm?=
 =?utf-8?B?Q3o2YlpQSkFzK2M4eGRJdVVMRlJxZEh4ZzlxNHllSFhucGpManZhdjE1MTM4?=
 =?utf-8?B?ZmdkS1J5WjRLYk9PcTRha2x1VXpjblR0bk11Z0JkN2ZhY2pDb293Vk9HZWty?=
 =?utf-8?Q?5908sgLNKSbpSZwrIzUyMPAzJADEFhDtCUpvYjy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 387c4e78-c9b3-4029-2c2f-08d8d7412459
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 14:50:05.8044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGVLEiKd4DwEUnfr+UjobNjiT+4qMmPV7Z85YSjlp9pypfFRv0P/YmxSFJsd/5YiOcV/hm7XibDc0TzXTguZYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3068
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 04:40:27PM +0100, Juergen Gross wrote:
> In order to support the possibility of per-device event channel
> settings (e.g. lateeoi spurious event thresholds) add a xenbus device
> pointer to struct irq_info() and modify the related event channel
> binding interfaces to take the pointer to the xenbus device as a
> parameter instead of the domain id of the other side.
> 
> While at it remove the stale prototype of bind_evtchn_to_irq_lateeoi().
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---
>  drivers/block/xen-blkback/xenbus.c  |  2 +-

Reviewed-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks, Roger.
