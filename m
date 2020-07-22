Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15CF22A029
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGVTcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:32:46 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:41952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726322AbgGVTcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 15:32:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtKB7J91GbWON/vzL+ZKDclb/ThdTtvNLEMRiewKkFrFSlKVosEGVq02Yw/y7CqNrmQ8EJzq1x0ccIZsXLlQDV8F/ie7283FgKeyDYAeu82uXJ5SKe9EK+GE0wCs/WQ3bMeOHC1Ez2KhfumnyhCfshzaCH4piFDa2UghKB3MAGeJs+ykEmLW2OpHpvBVqj43u1pKVlifXnDPp6CfQLQKCHNfbp8PgvRpUhjwAmasveIf1omX2QK7rtzl63hnhk7pcDn5q0CYOCqC0DHC/sWjCyvUEauFIVK/taTS2F0tZ5spLIby/5ua74fHiw/G7fi7Fd4EQTblA83/EDZ0PM6osQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7YQYqLY0KIf33/+rnFoLlAfsCNkGPL7PxoJM3ABH8U=;
 b=e45DEs3r6CO6DQ6/cigX2yibYWSB8ztV462R/ut9EEpiVhw4gYZcQR0TbscQV8Rq4E32ZUQFro3BEJ2JlPenJEp1iePl+1GKMGDDCp8j0q0Pu+OX+6/r2yQZ0KN5FmqfvvzPc15StG5TqESFWxxo8uX7WnqWBJ6J9ciP8CrnxMQ0SQiAVTfxoR2sM3PzawXdUvi8UYjlLz3k4rulLbgUFg/wpe60PWNZABJzAooAms8RTSvimZWN/X4jSpjI3VJQSZkdYaoY50aonVY4tZoIJ78O2HiRcaTxRzdp+SN42x3PNmyEqFuZJU0nf4OmB08w0O07AerKU2bstSyKfdLVhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7YQYqLY0KIf33/+rnFoLlAfsCNkGPL7PxoJM3ABH8U=;
 b=tmmbUj+h7vYtb8MMBAZRGjurnqqSkQTQkuURRsLJUzvQVNbHAsUD9aZhI9l2nQTuLAWaggYwf3QIJGt7BW0V/O8nWhO395JZ1zwejdy+POvGPQvlNru6PT3oWG3kbvOlvmynCVxjsz/Qm+jAXlYO8wr0rw1FTt6myZX5T99Wsk4=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB5986.eurprd05.prod.outlook.com (2603:10a6:208:125::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Wed, 22 Jul
 2020 19:32:41 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 19:32:41 +0000
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
To:     Jiri Pirko <jiri@resnulli.us>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200630125353.GA2181@nanopsycho>
 <CAACQVJqxLhmO=UiCMh_pv29WP7Qi4bAZdpU9NDk3Wq8TstM5zA@mail.gmail.com>
 <20200701055144.GB2181@nanopsycho>
 <CAACQVJqac3JGY_w2zp=thveG5Hjw9tPGagHPvfr2DM3xL4j_zg@mail.gmail.com>
 <20200701094738.GD2181@nanopsycho>
 <CAACQVJqjE-N4M0hLuptdicpfgRxV6ZhdYm0+zxjnzP=tndHUpA@mail.gmail.com>
 <20200721121943.GA2205@nanopsycho>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <40b71e67-d83e-9c3f-be8a-1c75b8c860cc@mellanox.com>
Date:   Wed, 22 Jul 2020 22:32:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200721121943.GA2205@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::13) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (5.102.195.53) by AM0P190CA0003.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Wed, 22 Jul 2020 19:32:38 +0000
X-Originating-IP: [5.102.195.53]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94e53631-f107-4f09-d2f2-08d82e75feb2
X-MS-TrafficTypeDiagnostic: AM0PR05MB5986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB5986A8F4D2D38AAC45BE7E18D9790@AM0PR05MB5986.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkKisK+n3GA7SC6KjqgJxoTkWiVfK4xwvWnYUYYzVS2VkEbXID+/3zaXU8Niyuue3LrJxL990vdNB3FWoTCsRVZpQT1z4aUiO4LR32g/M8GQZ6WwufSbJbdRQhcZ76eRJkTzLW4TsJAYnq3b7UGmthsOZEr0kzUZgKfEKLJ54Bx+5+RuOrlgpfl4GoRdOp6IDNgoH1uNIHOUeE9XJPMfOQR2IL/dPIGuvoEJQHiZV3sLJ68fNtvMuc+n1clR79D4BKPDdEuWlP0GAtUo3j0iTp6j1dUqe9xMxOezIbH8dusmnG6txYhpmE+aaz0YKr8AiKE1qsr9IBe2DgGdwjwNQFeprdC5W0g25nrurJJ89/WafLjOGvWLHVbEAi+IoqcD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(36756003)(6486002)(8936002)(54906003)(110136005)(31686004)(478600001)(86362001)(31696002)(16576012)(52116002)(8676002)(53546011)(4326008)(5660300002)(186003)(83380400001)(2906002)(16526019)(26005)(66946007)(66476007)(66556008)(2616005)(956004)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CvAxH6aCUjunxbmNduQ91UGoG7srbi8w6RmvXLhVhfeknw30A60M8sSR++w21TvRkpPEyK7VuoyGHHl0Q6L3OcvDGwrnenoTlp+TvjTGGVKsYEMBggpUtVMdbFrv1XjQe09rHtSxNKEG8UWOmfN388W0qT+Qr6urHobyPyYjgXfGaxciV06rjco/AyH5wlhaiVkzzBnsvOOk+EQJ8w5Z2QHxjYiM1FxGSq710zbEdwOCyzksUMN+NXqyHjAxdMXF0HsoIzRHGPHaDGQN2ot1ujFbxpfQp/MF/AKUWx8dUkWmzQbAkE/qJr1BBplSlLp51o79lH2DGEKUClHr7/GkdzZijl/KL/bE8IFaZF0rlu7j+LrLNP2WHPiTKc7o+YA9Rh4i5CovmK4F3My3QPsDTsh18TGgqI7JQ5N/hTAHl8mvUM1g0l3vel3e+jcjDlIeR9Lp8F9fJ2E473ekqdZBt6QAfhomePx3eRmQweJ0td8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e53631-f107-4f09-d2f2-08d82e75feb2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 19:32:40.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mxPIqSB5Ue74fUn042j61il+akKlGynAUaZoodlMxAKpNLvDU4KHknhNhmXIhb1uhGV/BgqgLyfgCzcklwQbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5986
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/21/2020 3:19 PM, Jiri Pirko wrote:
> Tue, Jul 21, 2020 at 11:51:21AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> On Wed, Jul 1, 2020 at 3:17 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>> Wed, Jul 01, 2020 at 11:25:50AM CEST, vasundhara-v.volam@broadcom.com wrote:
>>>> On Wed, Jul 1, 2020 at 11:21 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>>>> Tue, Jun 30, 2020 at 05:15:18PM CEST, vasundhara-v.volam@broadcom.com wrote:
>>>>>> On Tue, Jun 30, 2020 at 6:23 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>>>>>> Tue, Jun 30, 2020 at 01:34:06PM CEST, vasundhara-v.volam@broadcom.com wrote:
>>>>>>>> Advanced NICs support live reset of some of the hardware
>>>>>>>> components, that resets the device immediately with all the
>>>>>>>> host drivers loaded.
>>>>>>>>
>>>>>>>> Add devlink reset subcommand to support live and deferred modes
>>>>>>>> of reset. It allows to reset the hardware components of the
>>>>>>>> entire device and supports the following fields:
>>>>>>>>
>>>>>>>> component:
>>>>>>>> ----------
>>>>>>>> 1. MGMT : Management processor.
>>>>>>>> 2. DMA : DMA engine.
>>>>>>>> 3. RAM : RAM shared between multiple components.
>>>>>>>> 4. AP : Application processor.
>>>>>>>> 5. ROCE : RoCE management processor.
>>>>>>>> 6. All : All possible components.
>>>>>>>>
>>>>>>>> Drivers are allowed to reset only a subset of requested components.
>>>>>>> I don't understand why would user ever want to do this. He does not care
>>>>>>> about some magic hw entities. He just expects the hw to work. I don't
>>>>>>> undestand the purpose of exposing something like this. Could you please
>>>>>>> explain in details? Thanks!
>>>>>>>
>>>>>> If a user requests multiple components and if the driver is only able
>>>>>> to honor a subset, the driver will return the components unset which
>>>>>> it is able to reset.  For example, if a user requests MGMT, RAM and
>>>>>> ROCE components to be reset and driver resets only MGMT and ROCE.
>>>>>> Driver will unset only MGMT and ROCE bits and notifies the user that
>>>>>> RAM is not reset.
>>>>>>
>>>>>> This will be useful for drivers to reset only a subset of components
>>>>>> requested instead of returning error or silently doing only a subset
>>>>>> of components.
>>>>>>
>>>>>> Also, this will be helpful as user will not know the components
>>>>>> supported by different vendors.
>>>>> Your reply does not seem to be related to my question :/
>>>> I thought that you were referring to: "Drivers are allowed to reset
>>>> only a subset of requested components."
>>>>
>>>> or were you referring to components? If yes, the user can select the
>>>> components that he wants to go for reset. This will be useful in the
>>>> case where, if the user flashed only a certain component and he wants
>>>> to reset that particular component. For example, in the case of SOC
>>>> there are 2 components: MGMT and AP. If a user flashes only
>>>> application processor, he can choose to reset only application
>>>> processor.
>>> We already have notion of "a component" in "devlink dev flash". I think
>>> that the reset component name should be in-sync with the flash.
>>>
>>> Thinking about it a bit more, we can extend the flash command by "reset"
>>> attribute that would indicate use wants to do flash&reset right away.
>>>
>>> Also, thinking how this all aligns with "devlink dev reload" which we
>>> currently have. The purpose of it is to re-instantiate driver instances,
>>> but in case of mlxsw it means friggering FW reset as well.
>>>
>>> Moshe (cced) is now working on "devlink dev reload" extension that would
>>> allow user to ask for a certain level of reload: driver instances only,
>>> fw reset too, live fw patching, etc.
>>>
>>> Not sure how this overlaps with your intentions. I think it would be
>>> great to see Moshe's RFC here as well so we can aligh the efforts.
>> Are the patches posted yet?
> I don't think so.
>
> Moshe?


Not yet, still in internal review.

If won't pass by EOW I will send part of it as RFC.

