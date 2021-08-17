Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079493EEFF0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhHQQGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:06:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhHQQGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 12:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629216333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9gzzg2YwEyV3U2nBjj+cUEsKQ5qhPEMvgE1ztK9QOzY=;
        b=RsOsE75chmxexCnrSKGeVmVOk4nzscZ/rsNy3TWTDFvIArtPpwI1h4O1axFXYQBlDlYyR2
        RBydZX4QgP6VYXE//wjToDyWgUab4qewpgrTrwBOs6WMl3c84s9rvU2fGaNONg2JYx4BAI
        ituw7vHmI8/2aIr1THAKeZl2gqWnh40=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-OZ3emn1vMl2ZTP9iXYpo8g-1; Tue, 17 Aug 2021 12:05:32 -0400
X-MC-Unique: OZ3emn1vMl2ZTP9iXYpo8g-1
Received: by mail-ej1-f69.google.com with SMTP id e15-20020a1709061fcf00b005bd9d618ea0so2146439ejt.13
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 09:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9gzzg2YwEyV3U2nBjj+cUEsKQ5qhPEMvgE1ztK9QOzY=;
        b=aJGWPVpRN6qmlk+wZsQ0wrqB19Y3Sc7AQ3hLjm38kmx+6b+Rju498fkpR/CXswii94
         4T1iDTVaF6gs744n57xzbZ5H5pX8pEfHl4X1xy0kbGi79DBRltiPxRzDJpHdw3087cwy
         J2Kb9kXFOt56cLYp5z40/HydC+hoggw7zvQDREdMUjo7G1yl0rCxt+VvnEFUw6ssFTJf
         zKR/EQnhy4ZBnzDQIgzohDXXY9t4sJz3bYh2ZsRCPQOH0jefUp62tGTwbRZ/3YDEP+G+
         z1mjSm9UiUo5Pu+v40QJbIK0Gxw2fRMO992WSg3CK1FTBtJwH7WWUPoWuCPvOazaF0jX
         Z9Eg==
X-Gm-Message-State: AOAM531M4tNhStacxn4uzd1UX3/sH5Zbp5rg91+B7Vw5AOYzF75EjX9h
        NzwoJgX3jJqj0neQ3rJF/s2aS+zU/rgwJ7Eebu9fbC8RFlaaFk3bfbfhfTfhU4jFbF8KjOWn9QJ
        OPxdOqbemgV2mdUn/
X-Received: by 2002:a17:906:38ce:: with SMTP id r14mr4723480ejd.268.1629216330629;
        Tue, 17 Aug 2021 09:05:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwR1te4vfIy9M4SfzRe1qI8OFYLHdyH/4WNJ05ExASDPVCnSkyrwvya16nDl/TN1m4q9gXjsg==
X-Received: by 2002:a17:906:38ce:: with SMTP id r14mr4723459ejd.268.1629216330407;
        Tue, 17 Aug 2021 09:05:30 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id q30sm1286707edi.84.2021.08.17.09.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:05:27 -0700 (PDT)
Date:   Tue, 17 Aug 2021 18:05:25 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210817160525.GA20616@pc-32.home>
References: <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
 <20210812182645.GA10725@pc-23.home>
 <20210812190440.fknfthdk3mazm6px@pali>
 <20210816161114.GA3611@pc-32.home>
 <20210816162355.7ssd53lrpclfvuiz@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210816162355.7ssd53lrpclfvuiz@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:23:55PM +0200, Pali Rohár wrote:
> On Monday 16 August 2021 18:11:14 Guillaume Nault wrote:
> > Do you have plans for adding netlink support to pppd? If so, is the
> > project ready to accept such code?
> 
> Yes, I have already some WIP code and I'm planning to send a pull
> request to pppd on github for it. I guess that it could be accepted,

I guess you can easily use the netlink api for cases where the "unit"
option isn't specified and fall back to the ioctl api when it is. If
all goes well, then we can extend the netlink api to accept a unit id.

But what about the lack of netlink feedback about the created
interface? Are you restricted to use netlink only when the "ifname"
option is provided?

> specially if there still would be backward compatibility via ioctl for
> kernels which do not support rtnl API.

Indeed, I'd expect keeping compatiblitity with old kernels that only
have the ioctl api to be a must (but I have no experience contributing
to the pppd project).

> One of the argument which can be
> used why rtnl API is better, is fixing issue: atomic creating of
> interface with specific name.

Yes, that looks useful.

