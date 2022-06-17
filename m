Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8192754FE49
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbiFQU0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiFQU0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:26:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCAB5C64D;
        Fri, 17 Jun 2022 13:26:49 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HHOhi3013868;
        Fri, 17 Jun 2022 13:26:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=tFMPWp46LaTH3zGpohtB/XmxaQX58RagdZm/c51Yl9Q=;
 b=ZmLEc2I7uNDEdOyDAhA7NwJOvJrbfHHtea+5Pg+yaaHMbsTEe2rtnO3GCWOq/3rumE8d
 2RCcwWRsL/10V8AVra80X8jrHn/o2niMecs6CNWc0aSq8A3TFyNmCZk5kENQ/Kniaxkt
 7ZMkT/s75ER/Qc4DjEU2+muS1JmbvQzWlxs= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3grjetcvk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 13:26:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8ZK66UeZ4aCi1A66lZ7AM2jFtaMc7s+TCCb+QCKABF6sjI2i9sAU+Oz/gY5AWVCpMu5yTdw08do7eLW4LiH9Wiug9UelYjABsjkaUYvsl1E2Ml4Cacyzj9WFn3Pj053a8o3j8SATuYGkHNdFWBEvXXyJCBjnkzBDN6/FY23DqLzJzTzjlt3aKqFVcBmQLDU/N/0uzQ/NzBCBm3Oo6a70ANr+fn1aE2ZWQoV06yEXSaqEKaq5oVoUPrQPitCxYXvV/5YDkgD7ftTe3O35QdKbEF2vU/DNZI8D5qCwemrpRGa8ePfligfRaEAtKmxu3jkPxpTAwcKMofap9o4P/HRtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6N6vjahP3VoX5CYI1VWJ1KTe8ZeuWuvBtr25f/i8cU=;
 b=n5uo7gb0b7KFBr6IYoV/mv+IERWU2tj5KCNVKrkeWaIzsy16ikYmBPHnJcetwaRCFL099TfPoK5E0bc3uOIHmEgTsMRULV/YHWW0qMAQ2hbHM6luYZT8vTP7MRquLYOc2yOkmc/o3czBidYGlBbRHzFjOMHqFrbeiALU72jkcFxA4Q3cLQG87+FhWS9ArNz6L58b7mA77hXl7OeMYpOx/zaWLh5HL+zbPeDVwuTax/LmAJ1Qcuf2fzpyPVijTLFOEh1j3apf0tLD4xSCBRSddmCCwgeXwNEv3g/+ltUK8fvLoE6JoqPNjWgq5zhniaZNs268bF/pKiL1HI2UDJzVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MWHPR15MB1486.namprd15.prod.outlook.com (2603:10b6:300:b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 20:26:26 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 20:26:26 +0000
Date:   Fri, 17 Jun 2022 13:26:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/5] bpf: Require only one of cong_avoid()
 and cong_control() from a TCP CC
Message-ID: <20220617202624.pt6rlzhgwlgl6nci@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-3-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220614104452.3370148-3-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: BY5PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::20) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a607fad5-b3b4-4dac-85f3-08da509fa785
X-MS-TrafficTypeDiagnostic: MWHPR15MB1486:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB1486CD54871967ABCE64F42CD5AF9@MWHPR15MB1486.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mga7BM1nROE/sUhYRG9NrL+8LsCBRbsmNVLh3v1J+TkO1sbdLulerleBEOM4ECyBao7fOMmBf58cmsOG7RboQE0mcKq1NhTDb7OKWqylBERdCdrYHJgzh/h35tpzqptM1yPeioIyyTNowL82ej5UnGhY88iLnPo0SzlPd54W4PfSkaq8cyZImBfk5oHikVwbRmZ/jd4Bdo3MuaJ6HT2X/2n2OCK2DQtGAA+eJzH1bKazcoRPz29+2xRXRNRseS2sqWxlBWvc1ou2S+SLecTYL3O8dpB25VOBktHN4Ge6rPVs9eaI3AZ1AMZh3hMqOY7GNzKyRNWy/sSTzeNZNGe5E8hgjXtYf3S6ObN5+7+ENq2YLKOukjGy/rTQAU84W0lyePumB1eDIfDqqzdLvb8dlZHyskfrz+Q3kwKXAw6Ybsqxf1TKfAk5youModjTqbse6lmYBbSbS4zjZWyS7GS2zpHAnzFrl0mtzoZFzfaeNcEqxVbWldEIiUmNfSkb+d/sCrKL2luJncB3vcRrb1QZ26MVLbn/ZW8cZCtwQ6xBbaqXJl/mpNjaFbNozyCT/8SWpSghqdKYkSBzKaUMfkOAgAafGoiUNNIcaKgYE+C7/8pK3l3/vxhsxxF+AwJdvnveWC6PR320dOUC3Rlfy6MOFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(66556008)(4326008)(1076003)(6916009)(8676002)(66946007)(8936002)(66476007)(498600001)(5660300002)(9686003)(52116002)(83380400001)(6512007)(186003)(54906003)(38100700002)(6506007)(33716001)(86362001)(2906002)(316002)(6486002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?vXv471cLo9EuoW6UWc9OSLPYGCFHPW/00vBqAhUY/foTVF+VcwYnsw/jNm?=
 =?iso-8859-1?Q?z7ZRJKqDiWs3KGaJHfNgt430O5MniSArxw9HbghGtrlYHFMZkB0CD16MEd?=
 =?iso-8859-1?Q?/v4/b6u7If4iIJ27VHhQ0GZrTtZIzQPTqXEA1D3nLvXxIdS15ONZJEQ7Hq?=
 =?iso-8859-1?Q?8a8IXfyk88egSDjlEtjiNigIwkDiwsGybfeR9l3s9viUWvpBZ2sP4VgAHF?=
 =?iso-8859-1?Q?hGsY7pFFSjEUI5VKgQav5UzvcFj02Kwvkv+GXg/igITq8/69gfDhFzlTM6?=
 =?iso-8859-1?Q?AzS38W9CenVkWDqkW8yuYoFsUA4VoV2g6FsZXT4/EhfHJuVw1SrKjFJgt6?=
 =?iso-8859-1?Q?ce7HXF59UMAtnZO0mblW2M63eMBbZdhZ15dfdRwsay4WonATSzgt/MAmS4?=
 =?iso-8859-1?Q?aglM2uZCr4SBGMNMAuuRi2AH2bHD2LjSHS12nFDbYNX+kqAN7HF97zaPnh?=
 =?iso-8859-1?Q?gj/jTWcOafiGBjNYVJCR+L0bPkd0nX6HBKSnKoZlQXtkF7IITLRrUrP99q?=
 =?iso-8859-1?Q?S39X+MQ08oUTpNolXalzyLLnJ1r9M+BgT3JBvPM7CKWdU9ObckrQcwspsp?=
 =?iso-8859-1?Q?+iKggTBDdKr+7DipieodRE2rYEdsk/nNh664rcK2ivhwXptuZmESNND93K?=
 =?iso-8859-1?Q?NW42eqhu/ac+a13vXo92MqEhKZtS/TsNkn8d19R30i+g+euUEvWb+agCg8?=
 =?iso-8859-1?Q?a/yprvZiEsxVWOOcLtGqDnj9LS1KeXHGu4y8Iai4au9LYwSia6qBYXvjrZ?=
 =?iso-8859-1?Q?QLEtWQCI8FQlvhoHx3o7vG4iVYx8ObJ0sPgdyg3BEBfWrFmt8eREskZHm1?=
 =?iso-8859-1?Q?bEabq0Nk7z1Egd5JzAkeFWISpmwHa53sbS3+ChDjWjR0zxMOGMybud2OcW?=
 =?iso-8859-1?Q?ddSqeypAVVDAQJMpHpLzLwutBWGVcqOCgNI0EnXnEujeXd+29IIOUmv/in?=
 =?iso-8859-1?Q?B5oR+rVf0DXEmUifk3Gw4cfm0uWcLM/Qppv9rIwSshMrP/TqrvJHQ8r3OM?=
 =?iso-8859-1?Q?g1+IhoSYSX1ttBXLidF8JGM/VdIm+5IbzV9dJqIyuJs2CiKX461UWxce71?=
 =?iso-8859-1?Q?cDfOwJklWA6xcwrQmdrHTB5vzu5BoLV4QmgxD6Q8ExGBZweiB0h9IuftXD?=
 =?iso-8859-1?Q?oNLNofeK3YGBSyokHx8/7qAHRNsanlkS4P1puakQQuWstKAXgkCx/DUfOi?=
 =?iso-8859-1?Q?uBuyDEANd8qfyk9u0poG1iSpDvPmzUEjij0GLMeUhY++Fs8MSIPnwkXmiq?=
 =?iso-8859-1?Q?D29vOjOJrrUVs3sHrSDqr0k8y/IJQQla0bocIE7TXlP9BJsl2vwlFOHQ3F?=
 =?iso-8859-1?Q?gMq8py2c0UVqu/ZIXN9e94O5VqiHS4RyFfrG0x8vpi0I/n/R6zgAsrkeIh?=
 =?iso-8859-1?Q?s95tmx0p2ur9gu9d9vVPuqAe8m4J1FeqDJUYG2RwvE3R02MMTB2AKqM619?=
 =?iso-8859-1?Q?35QmfTuQWox4Ukv8ukJ2qQ0QL4uviFcoz2idbwDv/DiQ/LBSZILHOPNIjB?=
 =?iso-8859-1?Q?i41bvuRNeG4BRr5Ercf3hbubL868yazla3wovPubiSqni4phhX0TuxB5CP?=
 =?iso-8859-1?Q?3WokQebn6Vf7KgEIlQbzOIBsYDSjNFmm5IbkmJcUKiqRXMa8sHDISBNymr?=
 =?iso-8859-1?Q?M4X4vVImNLl0VG6Z3u/QkUsw81WEKA+BwzxnZ05ShP21C/WtuyOzMtd9Br?=
 =?iso-8859-1?Q?GPw2Qwj9e89HsD7HvC6kWLRl6PXVoQPBWUV0jjfLRazRCooInji9NolOmw?=
 =?iso-8859-1?Q?TigF90kymvjldlWpPwPlF7arsynZn0qRKPSTEvRu41N7ki9SFVJPjGnKKq?=
 =?iso-8859-1?Q?GHnfTG1LZ9/VCAkFrygE+DoDI7Q2vVw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a607fad5-b3b4-4dac-85f3-08da509fa785
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:26:26.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnXAHt9/kmk1ZZ9MRCMFsXppryyUYXtXXyUtks1fshq4mYo5k7in9t9oHtRTay6W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1486
X-Proofpoint-GUID: zMnkNUlu3rEFpfbcx1xUKiyZQ4sQwXFP
X-Proofpoint-ORIG-GUID: zMnkNUlu3rEFpfbcx1xUKiyZQ4sQwXFP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 12:44:49PM +0200, Jörn-Thorben Hinz wrote:
> Remove the check for required and optional functions in a struct
> tcp_congestion_ops from bpf_tcp_ca.c. Rely on
> tcp_register_congestion_control() to reject a BPF CC that does not
> implement all required functions, as it will do for a non-BPF CC.
> 
> When a CC implements tcp_congestion_ops.cong_control(), the alternate
> cong_avoid() is not in use in the TCP stack. Previously, a BPF CC was
> still forced to implement cong_avoid() as a no-op since it was
> non-optional in bpf_tcp_ca.c.
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
