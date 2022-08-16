Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476115956AB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiHPJiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiHPJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:37:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE87CC7417;
        Tue, 16 Aug 2022 00:59:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G3TFXn029659;
        Tue, 16 Aug 2022 07:58:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RLdsckxY2d7ns+AKUYbjz36pdlFrp/+9jjyy6lU73Uk=;
 b=QB+neVZQ8rRkOC3/fignpL/TxpXKx5J3F1rEEWttI6w92C1+OVU43l3EdE4SiFuTis/z
 xHZZzgEFDkx3DqRnCEqJLt+H5u8T2ZTjXlrkHQCQJYbVTWcRALPf9eEBLU9BobAya65F
 3mDxaOLiiBeh4VgRyXeJKEDaDFu4wxwWbz2RR06ljfXGZATl7QmZZiec43IHEeMbllYK
 jDjtCjuOHVZiUArBYKz5lPlyoDRY6/2gPh6sWushAThm282zMspG7vfG5nvpC1I7/55X
 MurbXWIljbiUVVYL6tsfXdSu4Pc+MrhnbVEgBEFxTOzY4vNdXmNDXSN1EZnCc/HuLv2P qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3js53rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 07:58:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27G6Wmin023494;
        Tue, 16 Aug 2022 07:58:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d2701t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 07:58:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqUnJzyK77bYJb13k5fsnqGtPUmaTpLUkUfTkrPdH7T6nZebLDAd+36odgXT3ouhasFYxrYk5JPKMT2WONI+bGwwpnDoBA+BmdPKiKKwrqYr47ze+EouapOns+1OgJKGgObrftVbxItCNWsdnc/oWtkmrAtX4fWVs79Com/TgI3b9PXPqdKfpLWJxnsTD2hMjLGKw9yJiKrSr2bWCc/4iBg2A2iPaV2fcpV1UhJ+3su8F4MTnVm8aRFD+KVK1WeQVZqWPflDCxJcmzXFru33FGaNyCN6WZ/uUTqqbsvG4vrzlyRHXYdiZ6B3TXSHEh6qA4dEtYnCoRpeOMepBWxHuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLdsckxY2d7ns+AKUYbjz36pdlFrp/+9jjyy6lU73Uk=;
 b=KmZQkoYHaZR2WNdcYLx8K367V+f2uohGIIe4xLtL1jDYPlcQZ63mFMftpLXIBrLwgs+DemWovN0G/jOxxNSRjdQ1Tbokmq86dJAV08Bd5vv0a6/5P10HiOyDVaEIptRp8jXrLaX++Wi2wl2uyVfxa2pYGX1SAObwr1qcxPEbbmyquMIDWM5vGxmtW7mf0oJYJM9JMs6/uqDfUQJ4gxGh9N3YlZqnbP5pEeaFIOOFm6z7DJJrWyibbFjSvxNGSqClL+h4Me73lRoHkjsSRBD/+kOhqPyVrlQg3IkD6W/rMQvmyeoWxhW3k0qCIclXP5WpwUCuOSywR33aPPECLOKS6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLdsckxY2d7ns+AKUYbjz36pdlFrp/+9jjyy6lU73Uk=;
 b=CWaEz1RnU5Jfw9YmskgXKl+cPMw8Sg5eVBh0w2n0tWyejC/XcaxWtVE2y1mWuMRK7QLRajjbTiuvWSDO3znlVvnrPw0CvkjyIwDusoGJiYPbM7EUOhpDz0Q8Gd2yOspFcbAHprQrs9B6ADq6lT6GtQJNR5t3IDIbnTb4OFPd5Ug=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 07:58:53 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 07:58:46 +0000
Message-ID: <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
Date:   Tue, 16 Aug 2022 00:58:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::33) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e315b8-f127-4052-704b-08da7f5d259b
X-MS-TrafficTypeDiagnostic: CH2PR10MB4391:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVh5d5UvK+Wo7ljX+Dws1IK1mNLgTEgspiGr9vH4dcJSsOsjzikneXN+3FcwF3C8s+Stlo3i9m03ZOqnNYWxcCsoKDJY6WtvkfnZDoxvW+1O12lgjfyJL38V8dxSr2PIs6mQ0FOO9vRJ3KmUulrK5DbE93tClMX+2rX9acZyV6R4YHVms4zoN3s/KiYxxo9xAgcZygaJQwcl8hJXwVJiYZnvZZ9D2+7W5MISHxusszhqpPydy04aRznHKlGfKUsQqpyuf8pWdtns8CNzJUr6o6Jx7yTeRL+CQQYANr3hlFj8rL9/qZo5z4vQvgapKQkBQuRHBM4bQtuv09QcJutoYni50vRo+CRd90u660ZdrNkeJS3epyvhHinisAHQ0HVWwDpmd5aQ8SisRVLbZkJWww5grP2HBGlHmoJd2zpv2fqHjIrvOH420dup8w0uKpJdycCLYzbwNQTpsMA0tkINxCzusCLbWbZPBhkYxFNzWmMQhVyzveyaVmxGdTugspRiSOkq/9yPtjUQ1GMz8/nmz+BtSYvxLJnOwQFo7EdF+EvwoDIdtaI5D9+5GVK28SBkFUsL/FD1UY04B02qMVpuGqSKQwY70btBe028ZfQUROAb7hI/8kEdjL4UtULIg9xV3PlTwDQ6YExcQOG6ionaPrnIoJd+yIJEFvwB/CsVr30lDHhsl3xVyMfJn3I9uch17cF2T/WZp/QMoiHc6QOHUjDSpoMP0k+IdzP2bW+u291PTEuvgMI5TlggXsBz5+Nk1ap3qO6Pxx6tw5xriv3QWuE5nfwC9LlepaoUemWT76D9bVRHvHyKf9Rx1NgL9ODjy7qfsLMiQ/QNSH5zOy91wAo/a0Da6pbIE/Xb9JXI6oH0JmGzIU9ySoKVp5aLU0P7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39860400002)(346002)(376002)(6512007)(2616005)(53546011)(6666004)(86362001)(36916002)(6506007)(186003)(36756003)(26005)(83380400001)(316002)(41300700001)(4326008)(31696002)(66946007)(66476007)(66556008)(2906002)(6486002)(5660300002)(478600001)(8676002)(31686004)(8936002)(38100700002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1BXYTZid1hNOVpDYjVRVzRJNmozQUo4U29RdW1uL0VDY3p5bmtEa09Xd2hy?=
 =?utf-8?B?Q0lteTNKRk9qWEtpZVVUS1czb09FMlJqeU51UlBCTFJ5VWNVR0oyZjFwQ0F4?=
 =?utf-8?B?aXozbWhmOGdOYkl3UnZ4MWpmbzUrQktYM29QODF2eDNlekxBRFRXeFZOdFB3?=
 =?utf-8?B?K0hFaGd5N0lvbHJRNjViVmptZXZaU0hFWWsvWlRVYkozcUdzT0xVekl3NHZ6?=
 =?utf-8?B?bWt3bGJKalVybkZxaFkwTURWazJ2VGk3WW9vWXRxVEpOWlFiU3Q5alFZWHEy?=
 =?utf-8?B?ZFRxdk9PMWpYbGJ3S2NFd2xlM1V0OG02emQ2M0M1QWY0YVNaRTlnRXpBN21l?=
 =?utf-8?B?bExIZFFobzhiSEVoWGkvQ3R1eUQ0L1EwY0c3RFcrY3pVSXFkMTZ5aTNobEVG?=
 =?utf-8?B?NnV6NTdhMExodUVrM2pQQXNiOVp6UlQ3WWcyUC9sMkFPUndTNk5JREJ2eWFI?=
 =?utf-8?B?bnk0a1ZLeWRkd2xGcDdwRTFHNksvSnhJWjF2aGxyVllIUHVpVExZQmY3RjJ0?=
 =?utf-8?B?d2srWmpvcE9vMExtR3JTY2orRVE5R1pOZE9WSVlBbkpvOENrVGVPZEFPUGZN?=
 =?utf-8?B?ckxtSXZaT2hDYndmNk0vc0tIYjB3OXBxQzcrY0k3UFU2cXNWK2tnYXRZdE0r?=
 =?utf-8?B?TTVDV21wcnMxYk45d0xWY3EzM3owS3JtSi9kOW5rb29BNlNLNWZsUjJXQ3lr?=
 =?utf-8?B?aHFWZ0xRQldEcWgrWk1CYXRsMnQ5NjJxTWNWM3FFWFRuRElRQXZKcS9rQ213?=
 =?utf-8?B?UExLblYzMHR0NWlEdVJ6YUxBZ0xsUWFUTlpnMzhpbFZXQUxzS0lDcVRsU3A2?=
 =?utf-8?B?Z0pkcW5OeFV1WW45cW5GbHo3eWQ3N0pDKzU3dS96SDlQVFYwejNEUFJnUXll?=
 =?utf-8?B?c2pHczNJcHpacEJUemQ5SjI3TjFqUFg4ZjFPRXZjQ2FmZW51dUdoZWp6U2pP?=
 =?utf-8?B?dkI4OTViRVYzckdYNW95QXFKeGdOYjZiQUxZaUdFbU0vcGE2THhyZDJuaFM5?=
 =?utf-8?B?WHMzOFhsUS8wTm5ESUdrWFhBRnNOTXVZQ0hmcDZ4OEpiRGl0RFpDNzZFZHFx?=
 =?utf-8?B?S2FlWFVIQ09HWU04SGpRYlVndGZkU1AvcWRiaFNqeCtoZnZWeVMyY2dZMFhq?=
 =?utf-8?B?eWpGV3Vta3J5NHA4Nlg0ZnB3ODZRQU96dWtYcTd6S0ZPTjFPQS9uWTFIOWlD?=
 =?utf-8?B?QllrSEdSd1Vudm1JeU12SVpHazRYR0c4QVc0N2hrQ0pjSXh4UlBLdlRvNmlw?=
 =?utf-8?B?SFlKa2FwWGFiZzJ1WlZGU29ISGl3dUh4RE41a2VOVjhFVFczMkhQeEVBRkFR?=
 =?utf-8?B?T2dZTWFiVVpJank0RDRFM3BwNW5wVnFncjN2VllJSW1rWklGU0dCbVBDSzky?=
 =?utf-8?B?NDZzUEdEUXV5TGpyQ1UvSjc0OEZZOWNRQ3NzYTFpb1dVZ3R4c3diTXIrRWNW?=
 =?utf-8?B?dTNCMWMzTHNHdFJhdlArc0JFbGhMTEViYWVoNjVxOS9kN1oxTHpTNVJMOFE1?=
 =?utf-8?B?ZFFodW9MbXR6WjU2RjVnZEM2NHdVeXlQOG9TeFBocWxXbk5SOTQ1MHFobWs2?=
 =?utf-8?B?d2xMYkVmWUpVRGRwS2VWNTJvYW9rL2cvZ0xjTmh4azQ3aFc3YXdjdWM4Ymp2?=
 =?utf-8?B?bDhVdXNHNjZ4c21FcDVtTnNOaXgyWksvQ2ZIN1dmOFFIa1dlVmgrV2FSUW5W?=
 =?utf-8?B?eTFQTDVCYzhWQkVoenhKUnIwWEJON29jUDltcmhFYnBCcmp2WExQWmdtMWN4?=
 =?utf-8?B?S0Ftb0ZNdExqb21mcEZyMGE0dldYZEt4Z2dvd1dzdEdod0lFQjhwbEhBZjE0?=
 =?utf-8?B?WkxabkNSNldVVlJEemdKNVVNR3pTZGZreE11M0ZWSVErcnc1QlFNUjNOS2dE?=
 =?utf-8?B?THBZVHBFa0lKZldwVjdXN2hoY3pKdFlVQmgxUFU0a2pQVkdITURxNFJjRDB5?=
 =?utf-8?B?T0hzVDV3Z0hJUmlkaEl2VjRWQ2E0d085VjNWL3VjR2hyZnh2RjBYSFRIUnAw?=
 =?utf-8?B?b0VhMjNvZW5YRFJtYWM5emRuYkRUNXo4L1hTN2I4SFZCMU10ZUdkYmRsNmgy?=
 =?utf-8?B?Tm5UR3RHZXp5cVBWRmt5c2tGblVuWXl5NnFORW9wTFNGZG10RUVPc0l3ZWlq?=
 =?utf-8?Q?m8V3gmZFgn8DoGOZ+QnJr3XW9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NnhNVkFEZk1oejU4Y01xRi9taThQUEFyc2ZZQ2ZyVHpUZWZCSmE0V1owT2tw?=
 =?utf-8?B?YzUremdPMUZMaWdPSVhJMHovQnV4N3RCRlowZ1FMM29sNkNOYmZDU0ticVlD?=
 =?utf-8?B?dXlna2M4MEQrZURFaGdSV1dXMWRuMDdnYkJ1OFNKclVuT3FCeVFWZ2xZTzQ2?=
 =?utf-8?B?akIrUitkOGNBZnZETVlVV2Z1SDhyWDVaOGhoaXIxNTRhdENmcy9kazZUdFo3?=
 =?utf-8?B?eXRYUGVkR1hKUUE4RW5DMEdLZU9mTnd6SS9raEUyUTBtWFlrWUNyb0dZQVoy?=
 =?utf-8?B?ZTBleUh5TWRnQWZVQ2puTk83NEt5b1JSU1NsYjI1bnpBSmFYTndRbGlYc0po?=
 =?utf-8?B?Q2F6a056QWdIaUZFVURURjU0emxCN21yc0pJSXpSUDdEejlnWHQraUVmamJX?=
 =?utf-8?B?ZzNERW92VGNpK0dNWDZMdU1vSFpiTm1GN28zMCtSazhOakVqNlR6bjBQM0tO?=
 =?utf-8?B?RG5FOVhZbzkyOEtxeDNhZVp1Z3ZiazRIaFpOaVBMQ0VZa2NabVZ5TU4zbkdm?=
 =?utf-8?B?Ri9BNmYxU0FzcjVrNFNweXUzZ0RUaCtYSWVxdFdsU0hpcnNTYXczTk5uOExL?=
 =?utf-8?B?QWowbE9GVURtanRtMGFLMlN0amdKWjE1TmFoN1I1VEtoWDQ1V2QzQnRkSG5P?=
 =?utf-8?B?c21qK0d0cmxvSzdTdTFaRUxOdHU2cFYzSnk3RGV3NVppUXpNUkc0TjhjcHBM?=
 =?utf-8?B?V01IRHZ2akFEa3VHM2wyVHd5dU5KeWdRUCtJb2x0TVEzdlFoMDBYY3BmTTFZ?=
 =?utf-8?B?RnhySzBtV25lMzJaZ1BrTVhNUXo2cTVvZVBRNXIzK3dqSzNvUk5rMHd6NFVR?=
 =?utf-8?B?eldybGk2eDBIWW0yWjc4emRKWC9mbzN1WVZiVzhhSHU5MmJ1eC9WUmZKUHZm?=
 =?utf-8?B?V1VGZnZzWUtLcWw2cHlVVm00OXo4dU5QYm1XVW9pTUVUTC9qT0g5Y1I0S3ZU?=
 =?utf-8?B?T0dqMFJ0QkdtR0xyTWwrNVJuZnppWFlDZFI5YzBGVFh5aHQxL0Fxb1huaTVr?=
 =?utf-8?B?TUkwM1pFcjQyUWllOS9td1Z3V1BnZVc1SVc1N0h5OTdFTlgrZnV2VUtFM2hy?=
 =?utf-8?B?dEd1dFFIL0I2SWd4Y1dHWGxxdm45b2U2MGovbk1kNjZOcWtCZ2tvMXVVbko4?=
 =?utf-8?B?MkttOFhFZmpJYlBncE9uNkpUNlJ4VDdUNkVYQlkxdVM1elhrcU0yRnMrUDBl?=
 =?utf-8?B?dXpkRVE3SXlpYjlGaTJ1c0pKd0RFYjVkSVA3RHgrMlZQY3pvQ3JxNC84RWMr?=
 =?utf-8?B?VFJVeXJTeFBPczJGNDYzYnNiVTBrVTBXQWN4MjI4VG9DbHZ4WUY0N0lZR0F4?=
 =?utf-8?B?UUgzNUJJU2syTWVCOUpxVGFPejZ3K1dOR0pybFdQQVUxTVh0YzJxcExmSEM0?=
 =?utf-8?B?SlR3Wk10Z1FkNGQrUVVTT1pqTm5zeHhzTTBnUWFuNE0yVXc0aFFKYW5NbUVV?=
 =?utf-8?B?RWhZeVI5QnRWQU1pZENVSWZ0V3dwMExHT2lvZzFvV0M2OTFoNUJkcXNlZjBw?=
 =?utf-8?B?UDB2MTJVcmgxRnhZdW5mL2pkQU9EK0QvOFFuZVVNL1BuRWJxOXB6TmRHNmM3?=
 =?utf-8?Q?BI28VAprDkF/+ppmmfoqCHmiJc3IcnKhnEJXh6ilRvS7dg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e315b8-f127-4052-704b-08da7f5d259b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 07:58:46.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrL/frd1n6GsSdEFg64iJI0QaFcQYvNcZ2X+LdWGvFlBbK27MOhn4Spdzr3LoXi0Djk4YcUVYdM2lhi8zTJQVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_06,2022-08-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160031
X-Proofpoint-GUID: 2vR1YgGDIu6H6ddlhGXmD_HyKh4za7i8
X-Proofpoint-ORIG-GUID: 2vR1YgGDIu6H6ddlhGXmD_HyKh4za7i8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2022 6:58 PM, Zhu, Lingshan wrote:
>
>
> On 8/16/2022 7:32 AM, Si-Wei Liu wrote:
>>
>>
>> On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
>>> Some fields of virtio-net device config space are
>>> conditional on the feature bits, the spec says:
>>>
>>> "The mac address field always exists
>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>
>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ
>>> or VIRTIO_NET_F_RSS is set"
>>>
>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>
>>> so we should read MTU, MAC and MQ in the device config
>>> space only when these feature bits are offered.
>>>
>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are
>>> not set, the virtio device should have
>>> one queue pair as default value, so when userspace querying queue 
>>> pair numbers,
>>> it should return mq=1 than zero.
>>>
>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read
>>> MTU from the device config sapce.
>>> RFC894 <A Standard for the Transmission of IP Datagrams over 
>>> Ethernet Networks>
>>> says:"The minimum length of the data field of a packet sent over an
>>> Ethernet is 1500 octets, thus the maximum length of an IP datagram
>>> sent over an Ethernet is 1500 octets.  Implementations are encouraged
>>> to support full-length packets"
>> Noted there's a typo in the above "The *maximum* length of the data 
>> field of a packet sent over an Ethernet is 1500 octets ..." and the 
>> RFC was written 1984.
> the spec RFC894 says it is 1500, see <a 
> href="https://urldefense.com/v3/__https://www.rfc-editor.org/rfc/rfc894.txt__;!!ACWV5N9M2RV99hQ!MdgxZjw5sp5Qz-GKfwT1IWcw_L4Jo1-UekuJPFz1UrG3YuqirKz7P9ksdJFh1vB6zHJ7z8Q04fpT0-9jWXCtlWM$">https://www.rfc-editor.org/rfc/rfc894.txt</a>
>>
>> Apparently that is no longer true with the introduction of Jumbo size 
>> frame later in the 2000s. I'm not sure what is the point of mention 
>> this ancient RFC. It doesn't say default MTU of any Ethernet 
>> NIC/switch should be 1500 in either  case.
> This could be a larger number for sure, we are trying to find out the 
> min value for Ethernet here, to support 1500 octets, MTU should be 
> 1500 at least, so I assume 1500 should be the default value for MTU
>>
>>>
>>> virtio spec says:"The virtio network device is a virtual ethernet 
>>> card",
>> Right,
>>> so the default MTU value should be 1500 for virtio-net.
>> ... but it doesn't say the default is 1500. At least, not in explicit 
>> way. Why it can't be 1492 or even lower? In practice, if the network 
>> backend has a MTU higher than 1500, there's nothing wrong for guest 
>> to configure default MTU more than 1500.
> same as above
>>
>>>
>>> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set,
>>> the configuration space mac entry indicates the “physical” address
>>> of the network card, otherwise the driver would typically
>>> generate a random local MAC address." So there is no
>>> default MAC address if VIRTIO_NET_F_MAC not set.
>>>
>>> This commits introduces functions vdpa_dev_net_mtu_config_fill()
>>> and vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
>>> It also fixes vdpa_dev_net_mq_config_fill() to report correct
>>> MQ when _F_MQ is not present.
>>>
>>> These functions should check devices features than driver
>>> features, and struct vdpa_device is not needed as a parameter
>>>
>>> The test & userspace tool output:
>>>
>>> Feature bit VIRTIO_NET_F_MTU, VIRTIO_NET_F_RSS, VIRTIO_NET_F_MQ
>>> and VIRTIO_NET_F_MAC can be mask out by hardcode.
>>>
>>> However, it is challenging to "disable" the related fields
>>> in the HW device config space, so let's just assume the values
>>> are meaningless if the feature bits are not set.
>>>
>>> Before this change, when feature bits for RSS, MQ, MTU and MAC
>>> are not set, iproute2 output:
>>> $vdpa vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false mtu 1500
>>>    negotiated_features
>>>
>>> without this commit, function vdpa_dev_net_config_fill()
>>> reads all config space fields unconditionally, so let's
>>> assume the MAC and MTU are meaningless, and it checks
>>> MQ with driver_features, so we don't see max_vq_pairs.
>>>
>>> After applying this commit, when feature bits for
>>> MQ, RSS, MAC and MTU are not set,iproute2 output:
>>> $vdpa dev config show vdpa0
>>> vdpa0: link up link_announce false max_vq_pairs 1 mtu 1500
>>>    negotiated_features
>>>
>>> As explained above:
>>> Here is no MAC, because VIRTIO_NET_F_MAC is not set,
>>> and there is no default value for MAC. It shows
>>> max_vq_paris = 1 because even without MQ feature,
>>> a functional virtio-net must have one queue pair.
>>> mtu = 1500 is the default value as ethernet
>>> required.
>>>
>>> This commit also add supplementary comments for
>>> __virtio16_to_cpu(true, xxx) operations in
>>> vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/vdpa.c | 60 
>>> +++++++++++++++++++++++++++++++++++----------
>>>   1 file changed, 47 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>> index efb55a06e961..a74660b98979 100644
>>> --- a/drivers/vdpa/vdpa.c
>>> +++ b/drivers/vdpa/vdpa.c
>>> @@ -801,19 +801,44 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct 
>>> sk_buff *msg, struct netlink_callba
>>>       return msg->len;
>>>   }
>>>   -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>> -                       struct sk_buff *msg, u64 features,
>>> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 
>>> features,
>>>                          const struct virtio_net_config *config)
>>>   {
>>>       u16 val_u16;
>>>   -    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>> -        return 0;
>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
>>> +        (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>>> +        val_u16 = 1;
>>> +    else
>>> +        val_u16 = __virtio16_to_cpu(true, 
>>> config->max_virtqueue_pairs);
>>>   -    val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>       return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>>>   }
>>>   +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 
>>> features,
>>> +                    const struct virtio_net_config *config)
>>> +{
>>> +    u16 val_u16;
>>> +
>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>> +        val_u16 = 1500;
>> As said, there's no virtio spec defined value for MTU. Please leave 
>> this field out if feature VIRTIO_NET_F_MTU is not negotiated.
> same as above
>>> +    else
>>> +        val_u16 = __virtio16_to_cpu(true, config->mtu);
>>> +
>>> +    return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
>>> +}
>>> +
>>> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 
>>> features,
>>> +                    const struct virtio_net_config *config)
>>> +{
>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
>>> +        return 0;
>>> +    else
>>> +        return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
>>> +                sizeof(config->mac), config->mac);
>>> +}
>>> +
>>> +
>>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, 
>>> struct sk_buff *msg)
>>>   {
>>>       struct virtio_net_config config = {};
>>> @@ -822,18 +847,16 @@ static int vdpa_dev_net_config_fill(struct 
>>> vdpa_device *vdev, struct sk_buff *ms
>>>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>   -    if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>> sizeof(config.mac),
>>> -            config.mac))
>>> -        return -EMSGSIZE;
>>> +    /*
>>> +     * Assume little endian for now, userspace can tweak this for
>>> +     * legacy guest support.
>> You can leave it as a TODO for kernel (vdpa core limitation), but 
>> AFAIK there's nothing userspace needs to do to infer the endianness. 
>> IMHO it's the kernel's job to provide an abstraction rather than rely 
>> on userspace guessing it.
> we have discussed it in another thread, and this comment is suggested 
> by MST.
Can you provide the context or link? It shouldn't work like this, 
otherwise it is breaking uABI. E.g. how will a legacy/BE supporting 
kernel/device be backward compatible with older vdpa tool (which has 
knowledge of this endianness implication/assumption from day one)?

-Siwei

>>
>>> +     */
>>> +    val_u16 = __virtio16_to_cpu(true, config.status);
>>>         val_u16 = __virtio16_to_cpu(true, config.status);
>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>           return -EMSGSIZE;
>>>   -    val_u16 = __virtio16_to_cpu(true, config.mtu);
>>> -    if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>> -        return -EMSGSIZE;
>>> -
>>>       features_driver = vdev->config->get_driver_features(vdev);
>>>       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, 
>>> features_driver,
>>>                     VDPA_ATTR_PAD))
>>> @@ -846,7 +869,13 @@ static int vdpa_dev_net_config_fill(struct 
>>> vdpa_device *vdev, struct sk_buff *ms
>>>                     VDPA_ATTR_PAD))
>>>           return -EMSGSIZE;
>>>   -    return vdpa_dev_net_mq_config_fill(vdev, msg, 
>>> features_driver, &config);
>>> +    if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
>>> +        return -EMSGSIZE;
>>> +
>>> +    if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
>>> +        return -EMSGSIZE;
>>> +
>>> +    return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>>>   }
>>>     static int
>>> @@ -914,6 +943,11 @@ static int vdpa_fill_stats_rec(struct 
>>> vdpa_device *vdev, struct sk_buff *msg,
>>>       }
>>>       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>   +    /*
>>> +     * Assume little endian for now, userspace can tweak this for
>>> +     * legacy guest support.
>>> +     */
>>> +
>> Ditto.
> same as above
>
> Thanks
>>
>> Thanks,
>> -Siwei
>>>       max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>>           return -EMSGSIZE;
>>
>

