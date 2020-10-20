Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086AA293736
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389825AbgJTI4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:56:00 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:22639 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728724AbgJTI4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603184156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cyTGtx/rOF2ba2tN64af7NqljmW/O5Itii7JNFJVjGc=;
        b=Fj4kTECECTOBrwhpGsKisDBl0/UsuJaYhM3ntN5WkQPF3HoRTDGiHV6fCVL7vuFDTdtQWq
        NXy84ggoQcP0kaMk+d/DnOliJ8kfeU+kJzNSy1rZ0TAdajY7y0U4d9t6/SvGkeRU/qxyZD
        P8mWKGJ+bYOTmeEFG67cNTkrYC25rSw=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2051.outbound.protection.outlook.com [104.47.6.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-fSNiAbJoPxubMOIGcZQKZQ-1; Tue, 20 Oct 2020 10:55:55 +0200
X-MC-Unique: fSNiAbJoPxubMOIGcZQKZQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNxfbhf8gc/5YLzzShWYD0XrkHJm9eN+S/8H/EbERw71bDG6F23jxh/z192uC/IOJCCfARiBR0bALkvn99JE4wKhYSlQp7Yk0IhUAxEHEBlpmjMoIGJMOwYYkN/3vC3yQRDfZfPz1Cf+/BWkANsjOYD7WVDzckU+JOsO6rg7wLw1h9vBO96nTDOkPzaJWYnOXehoyrAugLCg9uwSfn88tetcBDrXwVlhsbD3Tou4ss+SxExBC0r6FjvVhOcl+uBOZ0WLllf0RH924UFAbdPCLkPTBB/LL/DiJVsZ9OQhx458rZta8O1o26DzAnByukj++eTuQVo7O+aaE6CgI0cLxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyTGtx/rOF2ba2tN64af7NqljmW/O5Itii7JNFJVjGc=;
 b=BRR5fxG6CGDYlNu9ov9ATKZ5xi8h5yx3FRngfkqXf135zxU38DrxamsIKeN8ur2CAkR340LPinjysoTA2Oiaa0ey2X9BD/LJB+ahCQzHBA14PQPFSOENXXVTPAfGgZWf5eZtgVgEFlfs/aDcDtMbcJG489bJIthS/7V7O99VjfCFfddemU188wtAleHM2GbtoLBbg2MW0ShJ00h/6GxQQY8IGm9chJYgyvmlKblf8qmHDCbeeA6pDjG/kRvKsb59Qwz96IjBUPHO4403rxI+N0FZUsGQ03A+8hTj5uLRaIPopG5ROsoTOpaSpP9PHDfFnubY1dGuLhk1hC5Hnn8svw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB8PR04MB6492.eurprd04.prod.outlook.com (2603:10a6:10:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 08:55:48 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 08:55:47 +0000
Date:   Tue, 20 Oct 2020 16:55:38 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201020085538.GD23594@syu-laptop>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-3-coiby.xu@gmail.com>
 <20201020083609.GL7183@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201020083609.GL7183@syu-laptop>
X-Originating-IP: [2001:b400:e256:5604:908c:43ff:fe8c:2fe3]
X-ClientProxiedBy: AM0PR02CA0103.eurprd02.prod.outlook.com
 (2603:10a6:208:154::44) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (2001:b400:e256:5604:908c:43ff:fe8c:2fe3) by AM0PR02CA0103.eurprd02.prod.outlook.com (2603:10a6:208:154::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 08:55:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6458166e-0757-47a2-c3cb-08d874d5efb2
X-MS-TrafficTypeDiagnostic: DB8PR04MB6492:
X-Microsoft-Antispam-PRVS: <DB8PR04MB64924F0F1EB677D25A3FBB3FBF1F0@DB8PR04MB6492.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4yebwksID1JFCBa9tiUGwsCnLzLj2NEw0WI/AFQdO2RtosAAFhUOHDu6lORDMp4Ovue9N1RJchBDlj+15ULZ63hMXsLyODVDQSsGrjCrX7UY8d4oqXYP1MVzU/+QAmbr0bbeLgF587sQR3JHs4hsyM/Trnqy5CAyJQhBSOSZIu6Ue7pWAlW4NeMzRDmTeO7IILhVzL2tgZ8aFnC/aIFUwqs4QPN+Bw1sYlnyQYeHC3DGXY+UgTI7vv2dSzGftNrM9PbCRuZc5qvjCFbV6SJhs9d0nbEppbyPsVzebei5KJZAbohvFF4YngdHjLkuBQ7aG4D9K3jCI0N7zHEZZqztvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(16526019)(33716001)(33656002)(8676002)(54906003)(558084003)(8936002)(6496006)(186003)(55016002)(316002)(52116002)(86362001)(6666004)(2906002)(4326008)(6916009)(9686003)(1076003)(478600001)(5660300002)(66946007)(66556008)(66476007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8y2vG3EIY+pEEKNQu9Gm5v96aCtnDblyi2KbPS0yKG1RMvZjo2t4HXo+FbcppAuq/jKgVV1vaOQT2in9j6xelWmseQ7HXoi6wL+qoKj0N6IzxJkHeaKezC1ruz09oHhsZGit5eBWhm88BVNor3UJTQvPH1QfhT7FmvxfWV8ptHkwK9r2eiijWd9fkPLJg3BN9MUyBFIBRe9YgOuTs6VH6W9XJA1Jytsh5cUCK/U7QV1Mm9mZ2u8IiGBwje30dmz+qT1zCN+XrlY9w4npXK37gAUYu76sWV6NPK/0aSt0SB4gV6ELIDVAr72mQCNFItBgpR3vie3gxvuWzyIaR8w0rm8e4TxprVOVHPIoiCD2Y5IQ3cnCqVuddlVtwGOAW2FZINI8YlD68Ce4GGE3UZTKAz4OrjaVCeJmGOhxwLw2R2h/sOq5gPyKRySeXQRUYdv/lfGSAOdx/lu3QTXVn6XDBIy8a2mBU8zKXrJic5JTeCZtpZhuctKIvxJMeaMVuETdIISVt5lljMIvTX47+j+qyO1TWrXTjN/CXnNb2XauRr3y6PFOAURmvm8DJk2BWZA8zTY/fdakw3D13M62es1AKIUJoZ8p6g+hxD+5yd9hEW2HTsIWBerA9c2Het0AmCNkZGQ9P5RpYF4dwH2Ni0vltl5U9yZCn4fkPF30U4rfa4TCmOEnIIlvK5KfC1JDXivU0XIPALU8foCL2fGXSjpaKA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6458166e-0757-47a2-c3cb-08d874d5efb2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 08:55:47.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEgfcem5j+zivCfDyHeErHoJDpYmztr724CUvMeo1r6jrovWXTfa6kCWlaKhfFPldpb9ZdR1bGvwWYNcn9AfTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:36:09PM +0800, Shung-Hsi Yu wrote:
> This patch trigger the following KASAN error inside qlge_init_device().

Sorry, I meant to reply to the v3 series, please ignore this email.

