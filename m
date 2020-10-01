Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B34280446
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732287AbgJAQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:51:32 -0400
Received: from mailsec113.isp.belgacom.be ([195.238.20.109]:50969 "EHLO
        mailsec113.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732016AbgJAQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skynet.be; i=@skynet.be; q=dns/txt; s=rmail;
  t=1601571092; x=1633107092;
  h=date:from:to:cc:message-id:in-reply-to:references:
   subject:mime-version:content-transfer-encoding;
  bh=M5YyISvShmLvw2kswYwa2fXpeCsGnVcuj5czU/fFc+g=;
  b=X93wuRpraOIfF5oJbPlptGZC5ro7STnfTwQ1WTLsBlZ6aVWztb4YUM/5
   5nJW9yBicN7Vf54l6IwYz5bDR0k7ATilbWwDcQVoPZ+aXl+rA+KPmRqYy
   p/GuhTOkYSw7jBMRtmYbobTkV+GnkzSGeibFQr4FvP7IJXfv2k1DA74Qn
   4=;
IronPort-SDR: hIQ+hwNKXa24+rJu6YRwTARydlTZI5rLQvaYRpqo8GZA0rUL+j84ux2WtGxPIzl5HTKOUWIKOh
 uQN+BgpuDGRCplNyyXhRSUwj0u9x1Zqu2h7l4A5USWdRA5RfWB1lV/x4hwlGjPukMSIYce8Euv
 eYERj/0DPvy8VrOeQX3n5i22zCn9xoQxunuxKW8GW2p9j6Ju3YSOg5B81vzE30lqaLI9+EMUTN
 MVYY/ZSDzPGrsigsiaiqhUAfjXxvCa8+fjSOx1KjNLutmMm7/Fufs9qAFXl+cawaBB9O0o+OZK
 rGE=
IronPort-PHdr: =?us-ascii?q?9a23=3AcK28NBGo6VpbLzvRGOzNH51GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ7yp8iwAkXT6L1XgUPTWs2DsrQY0rWQ6PyrADReqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba5wIRmsowjcucYajZZ+Jqsw1x?=
 =?us-ascii?q?DEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U6VWACwpPG?=
 =?us-ascii?q?4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Ui?=
 =?us-ascii?q?ms4qt3VBPljjoMOjgk+2/Vl8NwlrpWrhyhqRJhwIDbYo+VOudxcazBct0UX2?=
 =?us-ascii?q?lOUMFKWixdAI6xdZcDAvAdMetaqYT2ulsArQG5BQmpHO7hyiVHiWT33aIg1e?=
 =?us-ascii?q?QqDAHI3BY+EN0TrnvUttT1O7sRUeuoy6TIwy/MYOhY2Trm84jIcRAgofeSUr?=
 =?us-ascii?q?Jsa8be0lcgGhrDg16NpoPrIymb2f4Rs2iH8eVgT+SvhnYopQxzvjSi28Qhh5?=
 =?us-ascii?q?TJiI8Xzl3K+yR0zJooKNC7RkB2Yd2pHZROuy2HN4Z4Td8uTW9stSomzrALuI?=
 =?us-ascii?q?O2cDQOxZkkwRPUdv+Jc5CQ7x7+SOqdOzh1iXF/dL6imhq+60utx+36W8Kpyl?=
 =?us-ascii?q?hFtDBFncPJtn0V0hzT7dWIReVl80e63DaPyxjT6uZZIUAojabbK4Auwro3lp?=
 =?us-ascii?q?cLtETMBC72mEHxjK6ZbUor5PSk5/jnb7n/oJ+TK5J4hhvlPasygsC/AOI4PR?=
 =?us-ascii?q?YSX2WD5OiwyKfv8EL6TblQk/E6j7PVvZPaKMgDo662GQ5V0oIt6xalCDem1c?=
 =?us-ascii?q?wVnXcdI11edhKKlJPpO1LOIfD+E/i/n06gnyx1yPzeJL3uHo3NLmTfkLfmZb?=
 =?us-ascii?q?t96FNcxxEpwt1E5JJbFKsBIPTtVU/1rtDYCQU5MwOsyeb9FNp9zp8eWX6IAq?=
 =?us-ascii?q?KBLazdq0GI6fwqI+SXeYAaoij9JOYg5/7qin85l0MdcbOv3ZQJdHCyBu5mLF?=
 =?us-ascii?q?mBYXrwntcBFn8HvgwgQ+z2lVKNTyBTam2sX6Iz+D47EpiqDYTdSYC3hryOwi?=
 =?us-ascii?q?O7EodRZmBcBVDfWUvvIqeNWOoGIAGTKc5niT8FHeyiVoUo/RKjrgn3z/xgNO?=
 =?us-ascii?q?WCqQMCspe2+tF/5uTV3T8o+DB5FcWW0CnZQWh+kEsTRC4w0bw5q0ErmQTL6r?=
 =?us-ascii?q?Rxn/ENTY8b3PhOSApvbZM=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BaAADOCHZf/1ULMApfGgEBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBARIBAQEBAgIBAQEBQIFPgxqBNIQ9kUmKHpIECwEBAQEBAQEBASg?=
 =?us-ascii?q?QBAEBhEoCgjUnOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoMZAQEBAQI?=
 =?us-ascii?q?BI1YFCwUGDgoCAiYCAlcGExGDFoJXBapZdoEyiQqBQoEOKoVYh3GBQT+DI34?=
 =?us-ascii?q?+h1SCYASbeZtTgnGDE4VqkW8UoRu1NoF6TSAYgyQJRxkNnGhyNwIGCgEBAwm?=
 =?us-ascii?q?OVAEB?=
X-IPAS-Result: =?us-ascii?q?A2BaAADOCHZf/1ULMApfGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQIFPgxqBNIQ9kUmKHpIECwEBAQEBAQEBASgQBAEBhEoCgjUnO?=
 =?us-ascii?q?BMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPRYI3IoMZAQEBAQIBI1YFCwUGDgoCA?=
 =?us-ascii?q?iYCAlcGExGDFoJXBapZdoEyiQqBQoEOKoVYh3GBQT+DI34+h1SCYASbeZtTg?=
 =?us-ascii?q?nGDE4VqkW8UoRu1NoF6TSAYgyQJRxkNnGhyNwIGCgEBAwmOVAEB?=
Received: from mailoxbe005-nc1.bc ([10.48.11.85])
  by privrelay100.skynet.be with ESMTP; 01 Oct 2020 18:51:24 +0200
Date:   Thu, 1 Oct 2020 18:51:24 +0200 (CEST)
From:   Fabian Frederick <fabf@skynet.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Message-ID: <577402571.31284.1601571084230@webmail.appsuite.proximus.be>
In-Reply-To: <20200930092904.394d7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200926015604.3363358-1-kuba@kernel.org>
 <121207656.52132.1601482805664@webmail.appsuite.proximus.be>
 <20200930092904.394d7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next] Revert "vxlan: move encapsulation warning"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev20
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 30/09/2020 18:29 Jakub Kicinski <kuba@kernel.org> wrote:
> 
>  
> On Wed, 30 Sep 2020 18:20:05 +0200 (CEST) Fabian Frederick wrote:
> > Thanks a lot for explanations Jakub. udp_tunnel_nic.sh is a nice
> > tool. Maybe it could also be used for remcsum testing ? I'd like to
> > check net-next commit 2ae2904b5bac "vxlan: don't collect metadata if
> > remote checksum is wrong" to make sure it has no impact as I had no
> > ACK. Problem is ip encap-remcsum requires 'remote' specification not
> > compatible with 'group' and only featuring in 'new_geneve' function
> > in your script.
> > 
> > If both vxlan_parse_gbp_hdr() and vxlan_remcsum() require metadata
> > recovery, I can reverse that patch and add some comment in vxlan_rcv()
> 
> I think it's better if you create a separate script for that.
> 
> udp_tunnel_nic is supposed to be testing the NIC driver interface.

Looking at 'man ip link add', the only option to enable metadata seems 'external' which can't be declared with 'remote'

Result when trying to create vlxan:

vxlan: both 'external' and vni cannot be specified

Is there another way to check both VXLAN_F_COLLECT_METADATA and VXLAN_F_REMCSUM_RX ?

I just noticed that before commit f14ecebb3a4e 
("vxlan: clean up extension handling on rx")

checksum was tested before metadata collecting in vxlan_udp_encap_recv() so there should be no problem restoring initial behavior.

Best regards,
Fabian
