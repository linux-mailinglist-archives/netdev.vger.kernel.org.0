Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A436B292D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCIPz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCIPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:55:54 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA52E7EDB
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijt9FyJov6J8bOMo3U8vqV+JwxUZoKlpms8Ro0KUrKNI2FoRaFLWp+c7s/Ef3oTWH0KQPfxjlrw/xwkmqX9pNRqYpV9W0l+1hUajeHzWPh9ZQqo+Eh+3ood1bU//KaejwN/BbEkmByz4NWWXGHcdXA2aODd5RTGSMbUJ6BJkTE2UP+2ehNaBf3hqCIxFqGMQQhvbsXv4aPADoJ/lCzQiPFF0ysF7X8oFh6v475Hsb0KcXJ2sipSRAtv69TerXmi0rcojixmQPIBnxOPFBdvtoLYyQMek9xBGDEIH/uXOcWIrqWjALSFKYLSSlzj9Rl5ISrEipPtbV6bTovWRy1JsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEJ9A8lzM7Bb3e4uoaEjOmU8DTpci4VrV5W1yJVbkio=;
 b=L3p594Al8lRgSGJmGIsZqrMQNdSCuqzQgBBO+MR8eDf1+aWY6Hgg5Znj34GbNbt1vHRegadbuztfSZuts88XDx8q5bQjY+mhIoJojXAIU4Xi2BIkXSGdSGyyLWtj2sBvOhBkojsAU3nm3Udo8vEibFvwMiiLO6iuAhGUD/QGR3evjh4TqoP3JEqLnJaqCXGKEfi9RpmP1F2PsjyZKQvssVeCPWVkfQEnAG5ZuOQ3EIqerkM254/gWrp5PkT8EQDP8eu6qITLFnc/HrpBYZfv9O9CvhvhoJ+9uHHfpn+YNTw8wBBquD8yZyjsxEjdUdcwcA79sCttXLhnaR80yXDbyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEJ9A8lzM7Bb3e4uoaEjOmU8DTpci4VrV5W1yJVbkio=;
 b=fDnDmrm1mhg2Bts8Nc09K3Bqe47GFncUp51tNWp1W1uclJnUrAYjerF2apVT9sYUDoWH4lLJbVkR7m4guYGRdsPUH8iV8WLWBYe7I7of6/7qQfi5yGCuj5jiI9ue6YuS8QrMt2F+ylOkjENmbH66LaegomK4sv3024RxL+skLUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4656.namprd13.prod.outlook.com (2603:10b6:5:3a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 15:55:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 15:55:50 +0000
Date:   Thu, 9 Mar 2023 16:55:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH v3 net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <ZAoBfnB2Gxr6dUV9@corigine.com>
References: <20230309115904.56442-1-edward.cree@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309115904.56442-1-edward.cree@amd.com>
X-ClientProxiedBy: AS4P191CA0001.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4656:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0a939f-2d0b-4fde-ca1c-08db20b6c164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34ENrmNndV8Ma0BqCADhojEmVWmlQSE3lLo6mVgjXFe3B7sD4+D9ZxhlO+WR6a1YuIVWokjz66Y4A+T94Ud2qZ3KDzm6eZXTepu4fxQbVOPJwJDFMWVYufZ35jCHImvNxQbJ9Sz58f3f/iJSRHXrDmJThML+gpjC/Cu0eEeJR5E4gmnhvwTNSprmVRdMipjcaUdPqSN245gk7b50z754dNwKRdRXvvgdDpulgk4WFQOUzatHON7c3lAPOWhaKAwqrHctId/+l+QQpMeE/pviCBicWtMMWqfxxpRSXw1XSA3iYhlLl7hXUKSO4YGku7+yvvOtuOplnlPP4s4PZVPQA9c3EYq6tKe2Okz32iWo9sFRBTZ+aeqSOZROS/MZKHUkdRFWcip1vSlTOMN5R0z8I7y1cxzj08p6GGX1sXI/3TOmINVwV+skbBKbBhlgz9OlIrs4lom76yx7QHN+6QZuCA6dIPyMKh7GlwnJTy9BMdQwwz+48OswJdnChdSUEfIuTi2NDVtNVhltVPTgnChRCP4k0cshFjmylxVNFMFTjFAgXZPrZ6CPRpJZfR7Bfl8xJ3rexhG4JBCcwRQfr7O9Du/NOZay1BgIe8Oij+aH5XAZYq6QOvy+A20e5X4M7vvJyi9pJEs5vWenDeC8SmFQzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39840400004)(136003)(366004)(451199018)(316002)(36756003)(86362001)(6486002)(4744005)(186003)(41300700001)(44832011)(66476007)(4326008)(5660300002)(2906002)(478600001)(6666004)(66556008)(6506007)(6512007)(2616005)(66946007)(8676002)(8936002)(6916009)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zfaVKHQAfgTSB66MHde4YIYE34pUfO2Mo4pdoX9aso7vasF8jlxW4uiVjY+d?=
 =?us-ascii?Q?HKj6O+rg0+LdVj0nfQttInscKJgUOY76FOx+vyS57wFDp6SJmYGSEq4Wk2wP?=
 =?us-ascii?Q?LrTuSMgj8C3EuzcZvp7mvSM++yqaiuuGRnaEqBgnUd9QnQyIZ8hQ6A01zSCV?=
 =?us-ascii?Q?q1kUMS/qh/Uwol5HUiwKC0AJLp6g1UJpVplys4q9CVEMDsydyw//4hUmu7DX?=
 =?us-ascii?Q?2SDMDVHm4L+k7xYr6gnYaXJgqibv/QDEFj0S4pPoh307REtI+HdduFTr9v6J?=
 =?us-ascii?Q?zAeNSE0Mt+zUrPUIXxQt8qQz7nSx7rroSdhJGCn2ePInzacznePSdrt/sGAY?=
 =?us-ascii?Q?CwZtkg/1PdKAv+UrUrOaNpsQ4l10WI5/yrCg95dt7TNLnracnVx7l3ZtCaBl?=
 =?us-ascii?Q?4XXUecIE+gjA5KOQ/CJ7maTex2fJYUVz4Ve4x5M/5FGQkNuBYFxx2CWIg/WI?=
 =?us-ascii?Q?3fzbpKT3inoPPLNfN7MIYnw0H+4zOfeRAT7UDAd+4oMEsMi9bcVbBYEXbP0O?=
 =?us-ascii?Q?9alCw4ab53KeMUJ2El5b+PPVCEQLVZAwJcqGetw5YO116uO8L1+nEUe2pkKe?=
 =?us-ascii?Q?6Wh4j95e7jnRtQ9xkeY/u3eYkGKrbbN3dGNoYFt3gXDl0sJc5x/4OQKp4iaH?=
 =?us-ascii?Q?vP39Rywv7xA8F8O1E15k0QUR2E4//9nFg0ZZESkN3ze+K99Q1CdMhIaUgx78?=
 =?us-ascii?Q?K4jqBkA00TAbKZco9K1GePdWlTt0Kpd5ffHVn89V6IApMpd+D3mpp/vBvcWC?=
 =?us-ascii?Q?ucelrjQ1n0cgermR5NOCIEYnHYJOfV+K5xI2S6jSExP1KLCbO6lCe4M+qo16?=
 =?us-ascii?Q?gJp4Y6lf/9uX0vUH6C6J/Ev8kiCgjvhU5Ekt77M7OzU7VLa4mW5bzlWpwzZ9?=
 =?us-ascii?Q?xMAFSX0sKSwe8vvB+9UgHK+s/ECn7GFbnFjZCAWG7lBJZMhVsUObHbX0U0Fb?=
 =?us-ascii?Q?/1teCT6VnN8ReaChpIorEyF2JMK5tzKYMcxTBAivkop0QU4P3h31B0ux1Zdm?=
 =?us-ascii?Q?U4Otf74KfKBNzZIbulpaF8pexrDCKgkuc0hGJL4pH0wDYl6PgJ+xTpNFJl9n?=
 =?us-ascii?Q?0pB1SZro7AT3wxqbzTHjG23Sr/y/3ktWYCkQ3XiOyFfWShgQ/uNGGEgAg8qg?=
 =?us-ascii?Q?XxKRtZX4hvQZ1hb2cwHxs5Q0c3W5jYjAD57sKye4oWwLA4sT0pEf1VvaIOVL?=
 =?us-ascii?Q?Uf51GFn312PPWZmJC4rVo8FMTVS2Uz4neN7WU9jbPgfyMDVhAtcvzBe6I0Yj?=
 =?us-ascii?Q?gupsHom/3jLMeh7S9YYnbh1B29AbAi/Rwbm7olwSaMVx7V/VMhzQ6r/0Hv8l?=
 =?us-ascii?Q?hjoVxIsu9Xjl2qvzMfubrHbEa83o8eNZ3Oih7ULZipYrUWXwa2B0gt3V2SyS?=
 =?us-ascii?Q?UUKOYTembrfiveR23QU9tp5eYmqAS7KUB5oICd2huDhYfj8usarzxgpM51QT?=
 =?us-ascii?Q?GSz08qX9uiAmIVka5JWnO/4tDpb9k4ayW1hl1jBtBQXwNarM6ug0MS0bes+a?=
 =?us-ascii?Q?QwXCsrwuHeiTr15qjYiV1+ttsnX1CAk5FfDx8x7pxVq8tBBWiRUWmwY8RHMr?=
 =?us-ascii?Q?6SyOKewJVueC6jJpXImCjTYyCCBwElmYcL4ry2TnBTmbs/KxAa0PvXfnfWGa?=
 =?us-ascii?Q?Z0HqPhxEVsceogo8p+e5QGUfv1GP2Oh89K7NmQW8P6z+QpgwVfIKycO3KoQa?=
 =?us-ascii?Q?cXxAFg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0a939f-2d0b-4fde-ca1c-08db20b6c164
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:55:50.6144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3dN0IX9Ve/iRIuEPaZq0inwo4aow5Lecxyl5/+YAZuQPaehXNzvtG+4hO8PvAnjFwmetzOglHjN045HxFIto4m59akdDuYRWbgGncfjKC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4656
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 11:59:04AM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 can pop and/or push up to two VLAN tags.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> Changed in v3:
>  * used VLAN_VID_MASK and VLAN_PRIO_SHIFT instead of raw constants (Simon)
>  * stopped checkpatch complaining about long lines (Simon, Martin)

Thanks.

...
