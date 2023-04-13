Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E206E0906
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDMIgR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Apr 2023 04:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDMIgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:36:12 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26BC903B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:35:54 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-lbg6TSa1PXWZr420N-2IhA-1; Thu, 13 Apr 2023 04:35:50 -0400
X-MC-Unique: lbg6TSa1PXWZr420N-2IhA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1FD43C025C0;
        Thu, 13 Apr 2023 08:35:49 +0000 (UTC)
Received: from hog (unknown [10.45.226.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B85FE18EC7;
        Thu, 13 Apr 2023 08:35:48 +0000 (UTC)
Date:   Thu, 13 Apr 2023 10:35:47 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Message-ID: <ZDe7RPlkemjOBB7e@hog>
References: <20230408105735.22935-1-ehakim@nvidia.com>
 <20230408105735.22935-6-ehakim@nvidia.com>
 <ZDbHI/VLKkGib3kQ@hog>
 <IA1PR12MB6353A4C01FE89E6256C89E94AB989@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <IA1PR12MB6353A4C01FE89E6256C89E94AB989@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-13, 06:38:12 +0000, Emeel Hakim wrote:
> 
> 
> > -----Original Message-----
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > Sent: Wednesday, 12 April 2023 17:59
> > To: Emeel Hakim <ehakim@nvidia.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> > edumazet@google.com; netdev@vger.kernel.org; leon@kernel.org
> > Subject: Re: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
> > support
> > 
> > External email: Use caution opening links or attachments
> > 
> > 
> > 2023-04-08, 13:57:35 +0300, Emeel Hakim wrote:
> > > Offloading device drivers will mark offloaded MACsec SKBs with the
> > > corresponding SCI in the skb_metadata_dst so the macsec rx handler
> > > will know to which interface to divert those skbs, in case of a marked
> > > skb and a mismatch on the dst MAC address, divert the skb to the
> > > macsec net_device where the macsec rx_handler will be called.
> > 
> > Quoting my reply to v2:
> > 
> > ========
> > 
> > Sorry, I don't understand what you're trying to say here and in the subject line.
> > 
> > To me, "Add MACsec rx_handler change support" sounds like you're changing
> > what function is used as ->rx_handler, which is not what this patch is doing.
> > 
> > ========
> 
> Sorry that I missed it.
> what do you think of "Don't rely solely on the dst MAC address for skb diversion upon MACsec rx_handler change"
> is it good enough?

But there's no "change of rx_handler". You're just receiving the
packet on the macsec device. I don't understand what you're trying to
say with "change of rx_handler", but to me that's not describing this
patch at all. "change of rx_handler" would describe a patch that
modifies dev->rx_handler.

"Don't rely solely on the dst MAC address to identify destination
MACsec device" looks ok, and should be followed by an explanation:
 - why the dst MAC address may not be enough
 - why it's not needed when we have metadata

> > > @@ -1048,6 +1052,14 @@ static enum rx_handler_result
> > > handle_not_macsec(struct sk_buff *skb)
> > >
> > >                               __netif_rx(nskb);
> > >                       }
> > > +
> > > +                     if (md_dst && md_dst->type == METADATA_MACSEC &&
> > rx_sc_found) {

BTW, why did you choose to separate that from the previous if/else if?

> > > +                             skb->dev = ndev;
> > > +                             skb->pkt_type = PACKET_HOST;
> > > +                             ret = RX_HANDLER_ANOTHER;
> > > +                             goto out;
> > > +                     }
> > > +
> > >                       continue;
> > >               }

-- 
Sabrina

