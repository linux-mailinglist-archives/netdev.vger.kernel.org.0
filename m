Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00CC27FA77
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbgJAHpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:45:50 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB53C0613D0;
        Thu,  1 Oct 2020 00:45:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w7so3725652pfi.4;
        Thu, 01 Oct 2020 00:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VN3W20DodgO3Zj44IKBt6WsTun4/50u7wi6510gCoWM=;
        b=R0fB6fw60vBL+fvSnqvbYPeevGTqltgDvi5HpaeO9dZQ6jb10RvzDOw8A1hAWHCRdd
         ORftCMUJGrC1b8H/CtmUYxsKPbX7FCdvcLxjz0O36Z9bM7qK4vDkSCMBW7CvMs/LHT7V
         R//EW1hv2DTpnwM01hyFdl/v/PLFDi0MIk08374InPERQ4f6cpDfCjSZOJTE1xFhT1nn
         jHY7HGAjCN9BaSlAhV5+aIu/w3FfmYoXinaXp1CNTosESjXkEkXfSA9f+LponD86GRiH
         kq/IHdWzxj/3/iaj47zN9R5U/5X27pabKhsWGcIPL9nj9o9gHofrDSOX2AbsvV4qX+W7
         /NgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VN3W20DodgO3Zj44IKBt6WsTun4/50u7wi6510gCoWM=;
        b=jx85/E5o86sAJB0km+RMbeADiygP6En0liJhZL2m9QS8+KZJj65i4s1jnif4DCIBur
         YgN8Vm2iVX0aN1qJC3DUKjQE2xnS4P03cPQkk4gR19cXuUCXTE3mxll6vnAW8gmNUZAN
         g23vELeS7lA7/fL3zQntuZhq+BeBd6x7QIWjqCmTbg7PzNB8FSZYaureyHi7R/xk5xmR
         R4gXsXwMc19h9uUjVtBrQac/Dx2IEgmYuvN0nCxmTd0bs5lIvn8vbcMelJMj90ftAn+v
         mFi2fpAFluGoYyCxa36xyPMCT1AzKlftf4zJ2inmxAwb1fex/U62KbXwnLc49HY5VNdC
         i/fg==
X-Gm-Message-State: AOAM530BM6Y0Cc8pN8y6qj+Sa5YpqIBBmhMhbtL5GHTr9cRgvjmT0T4t
        CaOPOFgdSm6THggldSqwnEDDP2DeInuNfQg/
X-Google-Smtp-Source: ABdhPJyp/ch4/L9rwgW9lIvX03PzXqb7gcqp6y3SXn7GGpNuBIWkLZ6lziCkf2XU3gQNQmVI3e+esw==
X-Received: by 2002:a17:902:760b:b029:d1:9be4:856b with SMTP id k11-20020a170902760bb02900d19be4856bmr5766836pll.1.1601538348617;
        Thu, 01 Oct 2020 00:45:48 -0700 (PDT)
Received: from Thinkpad ([45.118.167.207])
        by smtp.gmail.com with ESMTPSA id t24sm5316742pfq.37.2020.10.01.00.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:45:47 -0700 (PDT)
Date:   Thu, 1 Oct 2020 13:15:40 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        open list <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: bluetooth: Fix null pointer dereference in
 hci_event_packet()
Message-ID: <20201001074540.GA428447@Thinkpad>
References: <20200929173231.396261-1-anmol.karan123@gmail.com>
 <20200930141813.410209-1-anmol.karan123@gmail.com>
 <6F6EF48D-561E-4628-A4F1-F1AF28743CAF@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F6EF48D-561E-4628-A4F1-F1AF28743CAF@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 09:06:42AM +0200, Marcel Holtmann wrote:
> Hi Anmol,
> 
> > AMP_MGR is getting derefernced in hci_phy_link_complete_evt(), when called from hci_event_packet() and there is a possibility, that hcon->amp_mgr may not be found when accessing after initialization of hcon.
> > 
> > - net/bluetooth/hci_event.c:4945
> > The bug seems to get triggered in this line:
> > 
> > bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
> > 
> > Fix it by adding a NULL check for the hcon->amp_mgr before checking the ev-status.
> > 
> > Fixes: d5e911928bd8 ("Bluetooth: AMP: Process Physical Link Complete evt")
> > Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com 
> > Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f 
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > ---
> > Change in v3:
> >  - changed return o; to return; (Reported-by: kernel test robot <lkp@intel.com>
> > )
> > 
> > net/bluetooth/hci_event.c | 5 +++++
> > 1 file changed, 5 insertions(+)
> 
> patch has been applied to bluetooth-next tree.
> 
> Regards
> 
> Marcel
> 

Thank you :)

Best,
Anmol
