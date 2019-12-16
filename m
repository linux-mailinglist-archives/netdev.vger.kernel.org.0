Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED78611FD5C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 04:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLPDwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 22:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34052 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfLPDwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 22:52:32 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ighQq-0004o1-Es; Mon, 16 Dec 2019 03:52:28 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id B3B8E67BB3; Sun, 15 Dec 2019 19:52:25 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id ADFBEAC1CC;
        Sun, 15 Dec 2019 19:52:25 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Andy Gospodarek <andy@greyhouse.net>
cc:     David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Roulin <aroulin@cumulusnetworks.com>,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, vfalico@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] bonding: move 802.3ad port state flags to uapi
In-reply-to: <20191216031308.GA29928@C02YVCJELVCG.greyhouse.net>
References: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com> <20191214131809.1f606978@cakuba.netronome.com> <1076ce41-2cd5-e1d9-9b9f-ddc01385d343@gmail.com> <20191216031308.GA29928@C02YVCJELVCG.greyhouse.net>
Comments: In-reply-to Andy Gospodarek <andy@greyhouse.net>
   message dated "Sun, 15 Dec 2019 22:13:08 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13551.1576468345.1@famine>
Date:   Sun, 15 Dec 2019 19:52:25 -0800
Message-ID: <13552.1576468345@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Gospodarek <andy@greyhouse.net> wrote:

>On Sun, Dec 15, 2019 at 08:10:15PM -0700, David Ahern wrote:
>> On 12/14/19 2:18 PM, Jakub Kicinski wrote:
>> > On Wed, 11 Dec 2019 14:30:58 -0800, Andy Roulin wrote:
>> >> The bond slave actor/partner operating state is exported as
>> >> bitfield to userspace, which lacks a way to interpret it, e.g.,
>> >> iproute2 only prints the state as a number:
>> >>
>> >> ad_actor_oper_port_state 15
>> >>
>> >> For userspace to interpret the bitfield, the bitfield definitions
>> >> should be part of the uapi. The bitfield itself is defined in the
>> >> 802.3ad standard.
>> >>
>> >> This commit moves the 802.3ad bitfield definitions to uapi.
>> >>
>> >> Related iproute2 patches, soon to be posted upstream, use the new uapi
>> >> headers to pretty-print bond slave state, e.g., with ip -d link show
>> >>
>> >> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
>> >>
>> >> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
>> >> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
>> > 
>> > Applied, I wonder if it wouldn't be better to rename those
>> > s/AD_/BOND_3AD_/ like the prefix the stats have. 
>> > But I guess it's unlikely user space has those exact defines 
>> > set to a different value so can't cause a clash..
>> > 
>> 
>> I think that would be a better namespace now that it is in the UAPI.
>
>I agree that it would be nuch nicer.  I never really liked the 'AD'
>usage as an abbreviation for 802.3ad.

	Agreed, and, of course, the LACP standard moved to 802.1AX about
ten years ago; perhaps replace "AD" with "LACP" in the UAPI?

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
