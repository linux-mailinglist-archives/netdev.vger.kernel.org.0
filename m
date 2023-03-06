Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530E16ABDE8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCFLNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCFLND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:13:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D371EBFC;
        Mon,  6 Mar 2023 03:12:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgQ8p/VnPatkaYRatdCaYkkF4o8sHxBFlylXHxvJ/TQaTfrhP6V6nlPJnW6j4RzDmMv6Ntlw7yoYEcrMmyRP9IgNsHZ1VMt8Ut3FU7hZUhe8g1m1+Ge4M3DD3HfRFEPNqFpBO+HhA/GtfygberDvValamOqwA7ojKvdni+JPA0AbY8oQJi7ZwGezuIS3C0XL2lzNsUPUkjACIWNKOUatwlN+jK9rgKMxl3UFNYSa9PJ5CU3nQvRJEVqtGDGo/CornrQLnr6QfcVBa7Db7J7T2VsOMq++J7J5LuJX4ePt2jsfFWMpXOyzhd++He3Xb+i+aR7qugo1wS9IMIsJX9BFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1XKM2XQIai88d4ATpdjNhbS4BFmqrN5TYlUKnGP69s=;
 b=ZdNlzNN1V6pzAO3rZVcxk9sxNFUBPfdVvUV8GuCBMaEk/z/7imeNcF7E8+Mn4pcpi2IZhM8uqmRXOgR258JQbSakrXYQDZAbADNYs2IJVqil47iUGmmuwpgcLGZA7UxGSuKrLCEmfGZLQTFQa87U0iqZ/MiMpZ7JBbWsolJC0uJ4MdP+DcT6ZzOge0kSdOGUWwqV1FKyrUFlwWjSTne++k/biH6ekv6pCXJ8MeSMzJLFXCorLqXYwnZ3LaAUTKgxezb7pK/V+iof6GDJYAeiCV2gPEGM4k/EReExb4JboeF80wTReunT0XlHmSrE+CWUSWx3gT59fZSPbg3vqnURTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1XKM2XQIai88d4ATpdjNhbS4BFmqrN5TYlUKnGP69s=;
 b=glZnR+8QEusF4FgwvrYPsH+mURPTFWvTtxUAglXSadQ5xOjXSnE8x0S4DvPyhKQLrR6egkyBXTe7aScLZRDzK1LDkQDCN2BLoPXObxZodiwwJYlfmEcmoxLVV4awl2LY9jClfGtBDq1fE3F3VINEtB6d+z2P79moM9Wo8NEDqg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6184.namprd13.prod.outlook.com (2603:10b6:510:25b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 11:12:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 11:12:30 +0000
Date:   Mon, 6 Mar 2023 12:12:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-man@vger.kernel.org, mtk.manpages@gmail.com,
        alx.manpages@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH manpages v2 1/2] udp.7: add UDP_SEGMENT
Message-ID: <ZAXKmEEAySMWISBE@corigine.com>
References: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302154808.2139031-1-willemdebruijn.kernel@gmail.com>
X-ClientProxiedBy: AS4P190CA0045.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae4dfc1-c884-4ecf-6a11-08db1e33ad6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wDTtw3We+4rCSwfg1Iah4EfQepJU6SsbMCjqUIVWoO6H725EPgQA/HKBa3z1Zrt1/K4o720sHt6GWkjonhqm0ew5Q1ucxHuYv5BbfzwJ0TYvJSMLlwzQ4J0P/Qr3uFZO8lGUeX+U4TrTs/bw1fn76mu/nFtsR3vz6stKfZlj1CdR7IixtGpbNUZRdAYXlEsaFX/G9cARLCvgdqKDcr3gxvFWwqAqIdQTsoWgLpNNgXCxIQcKLYnbnr60DA2Es0ylkFL7q3wrv22f9A17wN5DXrHF/iveNzabteRU3F7spULBsuoDtVQzl1fK+96piMMzMV/JqRbIl0hfhqfCEDOKfx3WTS8YWGuy6wPk+zYZ2QTGHX1YZPwrfPXqhdEPdeFpi2vj5+WuHN81nf/2x43K2JA61ZJS8FHl2+nY3PKSzaGvD8KUSq2Im5a8GyeagrMIaWt6PZxZXTX8d6qxt3qLzewcbxY97PlNqKQqt4JahVIgW2Lag3HpXD9RnbpER4pxt3n1s2rUd6pO2wdaJxzR06iGW1hjbTq7x2GJVRogt2mJ4e1nZuVwSD8HtiMq2sAtG7KbhWFWaMhC3kgWYDA2HyUpwAcEMWJLHC+DgTQlSCS16COFa5/WPSga9JCIppStOGLVkfzQNKX8q/zWGnwc06WIrMo+3rhAGzJOKmF6pWgR0m5VuRmQOTLM1UvpxUP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199018)(6506007)(6512007)(6486002)(6666004)(36756003)(86362001)(38100700002)(186003)(2616005)(966005)(66946007)(66556008)(66476007)(41300700001)(4326008)(6916009)(8676002)(2906002)(44832011)(8936002)(4744005)(5660300002)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sRJl0cOWN9zGIO5PVgdC8YWwG9zMg2XsEu1b3Z5K+sn6h/NLNRH8Dt5ZqiE1?=
 =?us-ascii?Q?o2WIvb7M+78jf3K+hwDGae7jOE2+8vyw17t5jdrGlH7UT0vnCVez1aDqD3NT?=
 =?us-ascii?Q?H0z9BtlQ6dwOu7UEoOcIsWQY6+uwemyYMAv9rxO43z1BPCu2LZzstW3uezKk?=
 =?us-ascii?Q?Di+Wq+nzzC+gSPSlLjN092HUm9EZFMl7tkI0xbP7gyWx4/y8zIJ9XZ+1jtH3?=
 =?us-ascii?Q?A6PXfKncaug/0Usjvm0x9grReXUKhKDbEsWiwKby8M4KaWquovwQBkROGAfQ?=
 =?us-ascii?Q?7WjBRVenGwpWvkmtkgrvWtEOWK8uH+JfO+8YbapswfudM+sinuNCU32sxoxd?=
 =?us-ascii?Q?wn+DkA3lCPb45m8yoQVNfW3XU51OS9w3xOmPpWcLOFXmfcD2NKYR4KBKuX04?=
 =?us-ascii?Q?KnVpyAZ6ASzZ8A+EbF+GtBtd1pIMQud2XiRacOb+W26OZWeiDjyuL+zHv5ev?=
 =?us-ascii?Q?DHBNv8mqer6ipOTzls5P6goY/PEcMNss70W9P4fmBlV1ZYpYbJyM7VrdPRIs?=
 =?us-ascii?Q?h88ubr5tk5FFsFO+gVlHqZTV/8yzzs9VRjkfAjydwDYF6fCvjtxsbJSZ16RL?=
 =?us-ascii?Q?rRTLff3+bFDEFxfyE79d4TIDwLdfgPz6NjVd9x+gKSZziEizW1uoJWIre402?=
 =?us-ascii?Q?EV4es8KnOal9y3wdj91j2MEwkKBi536TpIUoMR4iSP8HQnEmvPqym8KHtmfo?=
 =?us-ascii?Q?NjimcoPO0QBkxuLKEe/IMjVPPEjwM9JqQbsXrOyjpPB225PzvWnP5GwXAll1?=
 =?us-ascii?Q?/cUCQ2PM7d/91JIDvKh4P0Go5GN0emedtm6PEm87Z830SI1oS724L7iAZ/0X?=
 =?us-ascii?Q?yr+5e8lG2j0GXjG0KaDhLk58qIB4PXYxvCNLSmRUhpU4jCqgN/nFL1KxYk1i?=
 =?us-ascii?Q?E3n9X9gUGnBq/SCGJk5pF3lB/Bncydsni6J6RLxJvIqsS8/N4ul5CFQcgEr4?=
 =?us-ascii?Q?dm7WEOMS6zwp1nl6HrgXfMLZrOVkBV8TaToy5OFS0JRQlE62C0uvO9rMX7F6?=
 =?us-ascii?Q?6w2VzmWV7CSKPbU63+RnwXXRr/A+JKSfc9L2T1FolEnbx9LvqUrCOug9gcto?=
 =?us-ascii?Q?Ns+lHmICkbNhJX6Sbl+rBQ4VMmMlCd9+xf2CPxEEBdvKQA3W8AZauZBwiR0N?=
 =?us-ascii?Q?7GFils9603Fa+/dij93p+P8U8Z0BkkxmrzK/fCGUtN5gRzGNVzkh6PiShwQh?=
 =?us-ascii?Q?7Uy1VhhTVV+lCgk6RxeZZQ7TIIClTuKTvRujj0uZbN6SvWnyE2PTtDSJCpm6?=
 =?us-ascii?Q?BLOUTxQxyNVSN6ltj0+r72vwmQrHeS8RZCAgiALvYHPzglgBB0sSfcfz7wQo?=
 =?us-ascii?Q?oJqYGjR442UiK5bZ+rVGSu6knXiIJXLLyPwOYG7XdZPgGYIDZRppu+b55hlp?=
 =?us-ascii?Q?T5QO+7TM/URMiWMhL9gdEbvHJ+VdoDOlngvlyClszOycibWJnulEAJlNNFpb?=
 =?us-ascii?Q?L9t+E2MRfI26qQyDPgpqqv1WfEpIs6rqj7Vjf/oFJ3EWjROW4aVwC39/hPD9?=
 =?us-ascii?Q?88ipuEQC24jjYiIR9nFJXNIF9Y2RrF72oqxlxpOVvvnssuI3ON6Mli/DJrpr?=
 =?us-ascii?Q?PC9eZv11FbiANQS9WNlPBZBq/n3xvJohArGeQ467t6B/mQJjH0wjipbHsRGd?=
 =?us-ascii?Q?Upfcbv0oCyMt3jZJIjXiOT3u861x86ewZenpT2/g0hvK20gwx4ZuFc6XDQOI?=
 =?us-ascii?Q?MpbqvA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae4dfc1-c884-4ecf-6a11-08db1e33ad6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 11:12:30.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nS812/UkgdKui30pi32ww4oETdnQBKmRXovYPtGV7gJwcn/Xd81rmIJvVC7TjnTggWF9emvmM3T2khiasl856tsaR+bVd0CJSUBq89xJAEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:48:07AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> UDP_SEGMENT was added in commit bec1f6f69736
> ("udp: generate gso with UDP_SEGMENT")
> 
>     $ git describe --contains bec1f6f69736
>     linux/v4.18-rc1~114^2~377^2~8
> 
> Kernel source has example code in tools/testing/selftests/net/udpgso*
> 
> Per https://www.kernel.org/doc/man-pages/patches.html,
> "Describe how you obtained the information in your patch":
> I am the author of the above commit and follow-ons.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

