Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E32CC13D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbfJDREh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:04:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387593AbfJDREg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 13:04:36 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x94H4RhK144718;
        Fri, 4 Oct 2019 13:04:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ve8g2v29p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 13:04:32 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x94H4WET145511;
        Fri, 4 Oct 2019 13:04:32 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ve8g2v209-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 13:04:31 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x94H0VeU007807;
        Fri, 4 Oct 2019 17:04:10 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2v9y58upm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Oct 2019 17:04:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x94H49xw49021210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Oct 2019 17:04:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2378CAE066;
        Fri,  4 Oct 2019 17:04:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88E43AE063;
        Fri,  4 Oct 2019 17:04:08 +0000 (GMT)
Received: from [9.53.179.215] (unknown [9.53.179.215])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Oct 2019 17:04:08 +0000 (GMT)
Subject: Re: [v1] e1000e: EEH on e1000e adapter detects io perm failure can
 trigger crash
From:   "David Z. Dai" <zdai@linux.vnet.ibm.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
In-Reply-To: <CAKgT0UdXLvAYeiO8Yb9DDN=8kB4ewOhcVjKqS+UOy60kY6mX8g@mail.gmail.com>
References: <1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com>
         <CAKgT0Udz7vt5C=+6vpFPbys4sODAZtCjrkSvOdgP80rX7Ww+Ng@mail.gmail.com>
         <1570128658.1250.8.camel@oc5348122405>
         <CAKgT0UcHvAQoChS1bkV8LsxaJcyRrTSPru+qsYXBsxHgr+aJmg@mail.gmail.com>
         <1570147335.1250.46.camel@oc5348122405>
         <CAKgT0UdXLvAYeiO8Yb9DDN=8kB4ewOhcVjKqS+UOy60kY6mX8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 04 Oct 2019 12:04:07 -0500
Message-ID: <1570208647.1250.55.camel@oc5348122405>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-36.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910040146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-04 at 07:35 -0700, Alexander Duyck wrote:
> On Thu, Oct 3, 2019 at 5:02 PM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
> >
> > On Thu, 2019-10-03 at 13:39 -0700, Alexander Duyck wrote:
> > > On Thu, Oct 3, 2019 at 11:51 AM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
> > > >
> > > > On Thu, 2019-10-03 at 10:39 -0700, Alexander Duyck wrote:
> > > > > On Thu, Oct 3, 2019 at 9:59 AM David Dai <zdai@linux.vnet.ibm.com> wrote:
> > > > > >
> > > > > > We see the behavior when EEH e1000e adapter detects io permanent failure,
> > > > > > it will crash kernel with this stack:
> > > > > > EEH: Beginning: 'error_detected(permanent failure)'
> > > > > > EEH: PE#900000 (PCI 0115:90:00.1): Invoking e1000e->error_detected(permanent failure)
> > > > > > EEH: PE#900000 (PCI 0115:90:00.1): e1000e driver reports: 'disconnect'
> > > > > > EEH: PE#900000 (PCI 0115:90:00.0): Invoking e1000e->error_detected(permanent failure)
> > > > > > EEH: PE#900000 (PCI 0115:90:00.0): e1000e driver reports: 'disconnect'
> > > > > > EEH: Finished:'error_detected(permanent failure)'
> > > > > > Oops: Exception in kernel mode, sig: 5 [#1]
> > > > > > NIP [c0000000007b1be0] free_msi_irqs+0xa0/0x280
> > > > > >  LR [c0000000007b1bd0] free_msi_irqs+0x90/0x280
> > > > > > Call Trace:
> > > > > > [c0000004f491ba10] [c0000000007b1bd0] free_msi_irqs+0x90/0x280 (unreliable)
> > > > > > [c0000004f491ba70] [c0000000007b260c] pci_disable_msi+0x13c/0x180
> > > > > > [c0000004f491bab0] [d0000000046381ac] e1000_remove+0x234/0x2a0 [e1000e]
> > > > > > [c0000004f491baf0] [c000000000783cec] pci_device_remove+0x6c/0x120
> > > > > > [c0000004f491bb30] [c00000000088da6c] device_release_driver_internal+0x2bc/0x3f0
> > > > > > [c0000004f491bb80] [c00000000076f5a8] pci_stop_and_remove_bus_device+0xb8/0x110
> > > > > > [c0000004f491bbc0] [c00000000006e890] pci_hp_remove_devices+0x90/0x130
> > > > > > [c0000004f491bc50] [c00000000004ad34] eeh_handle_normal_event+0x1d4/0x660
> > > > > > [c0000004f491bd10] [c00000000004bf10] eeh_event_handler+0x1c0/0x1e0
> > > > > > [c0000004f491bdc0] [c00000000017c4ac] kthread+0x1ac/0x1c0
> > > > > > [c0000004f491be30] [c00000000000b75c] ret_from_kernel_thread+0x5c/0x80
> > > > > >
> > > > > > Basically the e1000e irqs haven't been freed at the time eeh is trying to
> > > > > > remove the the e1000e device.
> > > > > > Need to make sure when e1000e_close is called to bring down the NIC,
> > > > > > if adapter error_state is pci_channel_io_perm_failure, it should also
> > > > > > bring down the link and free irqs.
> > > > > >
> > > > > > Reported-by: Morumuri Srivalli  <smorumu1@in.ibm.com>
> > > > > > Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
> > > > > > ---
> > > > > >  drivers/net/ethernet/intel/e1000e/netdev.c |    3 ++-
> > > > > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > > > > > index d7d56e4..cf618e1 100644
> > > > > > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > > > > > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > > > > > @@ -4715,7 +4715,8 @@ int e1000e_close(struct net_device *netdev)
> > > > > >
> > > > > >         pm_runtime_get_sync(&pdev->dev);
> > > > > >
> > > > > > -       if (!test_bit(__E1000_DOWN, &adapter->state)) {
> > > > > > +       if (!test_bit(__E1000_DOWN, &adapter->state) ||
> > > > > > +           (adapter->pdev->error_state == pci_channel_io_perm_failure)) {
> > > > > >                 e1000e_down(adapter, true);
> > > > > >                 e1000_free_irq(adapter);
> > > > >
> > > > > It seems like the issue is the fact that e1000_io_error_detected is
> > > > > calling e1000e_down without the e1000_free_irq() bit. Instead of doing
> > > > > this couldn't you simply add the following to e1000_is_slot_reset in
> > > > > the "result = PCI_ERS_RESULT_DISCONNECT" case:
> > > > >     if (netif_running(netdev)
> > > > >         e1000_free_irq(adapter);
> > > > >
> > > > > Alternatively we could look at freeing and reallocating the IRQs in
> > > > > the event of an error like we do for the e1000e_pm_freeze and
> > > > > e1000e_pm_thaw cases. That might make more sense since we are dealing
> > > > > with an error we might want to free and reallocate the IRQ resources
> > > > > assigned to the device.
> > > > >
> > > > > Thanks.
> > > > >
> > > > > - Alex
> > > >
> > > > Thanks for the quick reply and comment!
> > > > Looked the e1000_io_slot_reset() routine:
> > > >         err = pci_enable_device_mem(pdev);
> > > >         if (err) {
> > > >                 dev_err(&pdev->dev,
> > > >                         "Cannot re-enable PCI device after reset.\n");
> > > >                 result = PCI_ERS_RESULT_DISCONNECT;
> > > >         } else {
> > > > I didn't see log message "Cannot re-enable PCI device after reset" at
> > > > the time of crash.
> > > >
> > > > I can still apply the same logic in e1000_io_error_detected() routine:
> > > >     if (state == pci_channel_io_perm_failure) {
> > > > +       if (netif_running(netdev))
> > > > +           e1000_free_irq(adapter);
> > > >         return PCI_ERS_RESULT_DISCONNECT;
> > > >     }
> > > > Will test this once the test hardware is available again.
> > >
> > > Are you sure this is the path you are hitting? Things aren't adding up.
> > >
> > > I thought the issue was that the interface for the error handling was
> > > calling e1000e_down() but not freeing the IRQs? In the path where you
> > > are adding your code I don't see how the __E1000_DOWN would have been
> > > set?
> > >
> > > - Alex
> > We see the same stack every time the crash is triggered.
> >
> > My understanding is not that the interface for the error handling was
> > calling e1000e_down() but not freeing IRQs.
> 
> That is my understanding as well. However where you talked about
> adding the code will end up being before we call e1000e_down() won't
> it?
> 
Agree. It's possible.
> > In our case, on powerpc , if injecting eeh errors to reach preset
> > threshold value, it will be forced to be offline permanently.
> >
> > In e1000e_close() to bring down link, the check: "if (!
> > test_bit(__E1000_DOWN, &adapter->state))" is false, so e1000e_down() and
> > e1000_free_irq() are both not called. IRQs are not freed.
> 
> My concern is mainly that we don't want to mess up the ordering of
> things or perform the same action multiple times, or do things
> out-of-order.
> 
> > When e1000_remove() is called, it sees IRQs are not free, hence crash
> > the kernel.
> >
> > This is the reason I have the original proposed patch to add an extra
> > check in e1000e_close().
> 
> I get that, however the way you said you were going to change things
> doesn't match up with that. You are freeing the IRQs without first
> bringing down the interface.
> 
> > For the 2nd change in e1000_io_error_detected() routine, I haven't
> > tested it yet.
> >
> > Pardon me if causing any confusion, and Thanks for your time again!
> >
> > - David
> 
> I need to take a look at a couple things. I am not sure why the
> e1000e_close is even checking for the __E1000_DOWN bit. From what I
> can tell the other drivers are just calling e1000_down() directly
> without the check so I am not sure if something was added that makes
> it so that we have to be careful about calling e1000_down more than
> once or not. If not we could probably just pull that check and
> simplify all of this.
> 
> Thanks.
> 
> - Alex
I noticed this earlier like e1000 doesn't have the __E1000_DOWN bit
check in e1000_close(), but e1000e has this bit check in e1000e_close().
If we can pull this check w/o side effect, that will simplify all of
this.

Thanks! - David


