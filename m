Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113683378A5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhCKQBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:01:02 -0500
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:58016
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234348AbhCKQAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:00:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jotPBsxFX3oInL8wTF7zdlqysGs5TRnfJQ7UoWjEOVE5e8440Wmnm67RtsrUKQ8y8RnpH3ie/IX3sjjj8LdsetfiNsfpVfnM+rwOj2IrEgu7tA632+tzQgJT09ebWifO5BEO4MfJyC3sS5x+8ZJ0S/pmtzBv4/wVbTjsNw19erfHZq7f15kg4YHU+aXw3T14Rs74DkzOcaqxCN8o5Kixd7OQ/isimZ+ruDv+9VEETLDG4D9hjOZiRyEwpokmsdAutAJNQKoz5P7u2vbXDRTTOOQYVoxy9mVVefGXS3zVTOidTd5+coxPGGDYhq5LqmB3kk48abMJpjRhlVbt5WyfYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cqvUjzKH3YCcKyZ+IKwAFbqw+49VhqY3Myimbbgq/U=;
 b=nKdrkjDLuAUs/qzIg5FyxZXrQbIYIguyCfJFxCidGIVZHxZKIrI1InnZZHeVQ3VXJl/aDNazsCCC+8eKmCE9b36zNqJWwgdcuoRC5uDpJKFVYNkfJ2ifr2FgeROP1BbHzQNTQPuzJvFXpHofgdACJ5Q0rmqaA9yb8CqvsV3ERNBxHqyCnXtRsYbahaKSVvashKa9pVmAyRtNt7U55a1k1F2UNO5WzI/vNSTI0aJ43mlujhiuH8ZSxorqoSoorYSrlnP4mRZSSeqs4s1mSFIjQ4ftkPdHM3ZBeuzSGXp+W1qL3hYq9WnVX2iArLTCKB8aED0dBgFj0ior/O+5qF/NeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cqvUjzKH3YCcKyZ+IKwAFbqw+49VhqY3Myimbbgq/U=;
 b=I7TgJM2qjsxG/SU53OL07ZGNnjJX+KoKsDtX5OUfqhbZ6KFJI/vWqWxVG+DYBAdRsZFLExDIw/nqx6CFpxP4T78wg0F+7P9pTwGtmjg8hVNXJIR3VMBF9jcDmRxfZg/QjN0zwyyyyHkUWwfvdetFgxFbl/c2uuA2iaRb/OaJF/u/6H5edJlzBL8Y8kOuL2REHELYfAUZKOujgWuMAeZK1x/yzbUkTV7UelJdPrzYjICMs4cHoDXS0ZJS14Ih+89xrefRCRN+ffO4h/3FiBxHoqMVBKh0gh73v2sVZUhey0hEwvQWfGldsWoRYJWFZxM6SC0n3tmtdnUHeT5fBffA9A==
Received: from MWHPR2201CA0054.namprd22.prod.outlook.com
 (2603:10b6:301:16::28) by MN2PR12MB4189.namprd12.prod.outlook.com
 (2603:10b6:208:1d8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Thu, 11 Mar
 2021 16:00:35 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:16:cafe::a5) by MWHPR2201CA0054.outlook.office365.com
 (2603:10b6:301:16::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 16:00:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 16:00:35 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar 2021 16:00:32
 +0000
References: <cover.1615387786.git.petrm@nvidia.com>
 <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
 <b42999d9-1be3-203b-e143-e4ac5e7d268b@gmail.com>
 <87ft11itj5.fsf@nvidia.com>
 <33a20197-78b7-847d-7657-7a33ba9fef3b@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 04/14] nexthop: Add netlink defines and
 enumerators for resilient NH groups
In-Reply-To: <33a20197-78b7-847d-7657-7a33ba9fef3b@gmail.com>
Date:   Thu, 11 Mar 2021 17:00:28 +0100
Message-ID: <87czw5istf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b83bae4e-ce78-46fa-8a05-08d8e4a6cea5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4189:
X-Microsoft-Antispam-PRVS: <MN2PR12MB418957CEE4B2D619B416FDB4D6909@MN2PR12MB4189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omXhK7D8GwyrrSObRfEFDfm/72YqnSkC4UyXHwccCsoP1G42AYuoFurfC2jaOqdthSFmXHpKLr3UaoNOJXxlg37jxFPfkB1+FAKmn5AsxGVj54av8jJaPO0LWHOgT7HbfJq1A65YSB3onW9Tojmdz66FPaKFr9owHt3B+c6LryfePKx4HavQhTwcO1QIZAYNvD0y/vZrJHfhKkOWR2k0ZhW/ojrlAdDiiq+gMm45CCCKp94TERDoO2f2K4l2KQo8oPJNJawI8QJEDL04x2Q27hST0quGBJ3P880mgOrRsEFcQ8DcgTV4SDOmQOXzRfeN5INZLZZZG8YiaPiDwERwv/wGhdXEECFHzkI8UbQ0agLwpBUha+FaH6eERBTsm/SUypOMV0GFFvy4RuGZljeLAz41P1tr2Pd/LJutZCXL0fYhvZpeYpjwfasWEk+DLHahmforkjTqgg4JOaUsRgfFidaZl5IH0svRz5jQHNqdSriXiXk8Rej+WI192x4h1zImgrQAE5TJOD0TNHXo69rPX3UCdWSxENBp1GoNKThEGBdncQFNpGCyImOO5b8pPyqGpxkgZE1Nd4z5eeOTUw32TTsJgYhiGUNb6cF3unEn8EkX7CddTWsCRbmVy4GXGBd77jY1Ni7lFMFU9u4Vb98q4SpE9AP06WhhF8hfZAfzbuO17wgruuN5HnVjxk2OLEmq
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(54906003)(82740400003)(70586007)(36860700001)(426003)(478600001)(356005)(70206006)(8936002)(4744005)(336012)(2616005)(5660300002)(8676002)(7636003)(34070700002)(82310400003)(186003)(53546011)(2906002)(6916009)(36756003)(16526019)(6666004)(47076005)(4326008)(26005)(36906005)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 16:00:35.3735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b83bae4e-ce78-46fa-8a05-08d8e4a6cea5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/11/21 8:45 AM, Petr Machata wrote:
>> 
>> David Ahern <dsahern@gmail.com> writes:
>> 
>>> On 3/10/21 8:02 AM, Petr Machata wrote:
>>>> diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
>>>> index 2d4a1e784cf0..8efebf3cb9c7 100644
>>>> --- a/include/uapi/linux/nexthop.h
>>>> +++ b/include/uapi/linux/nexthop.h
>>>> @@ -22,6 +22,7 @@ struct nexthop_grp {
>>>>  
>>>>  enum {
>>>>  	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
>>>
>>> Update the above comment that it is for legacy, hash based multipath.
>> 
>> Maybe this would make sense?
>> 
>> 	NEXTHOP_GRP_TYPE_MPATH,  /* hash-threshold nexthop group */
>> 
>
> yes, the description is fine. keep the comment about 'default type'.

OK.
