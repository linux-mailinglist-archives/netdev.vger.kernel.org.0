Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597BCDF9E8
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 02:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbfJVApp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 20:45:45 -0400
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:60112 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727953AbfJVApp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 20:45:45 -0400
X-Greylist: delayed 17533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 20:45:44 EDT
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id x9LJqKac025351;
        Mon, 21 Oct 2019 12:53:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : date : from :
 to : cc : subject : message-id : references : mime-version : content-type
 : in-reply-to; s=20180706;
 bh=cBt5fU2/9AmS3ShWmDaFsUYFuVMc7BPprw0DZ9tzfHg=;
 b=C8wGeCCp+X3nGONoDqwpNwRBkFvwr4RHaSIude0/Be6gnJEY5SW1HUaTBdm+uASbVq1E
 QaTlKd3trzm2yeMaphlG2mmS0NqkqYKVrle1NYbOe5jlniKkd+TnLIiEo8iumsxBLD/i
 lfHFcZI5AVD0FRllUmlYtjsm4ryTpB1sGqLKxlfWVaF697QMoFlHvj0ygTRK57bedmEQ
 4ERmMpXCmXniF4SP14Rzhz8K8U+TgpWOs8GFQECEALuYnSErxhBZg5/OvsoO6zL+U8dM
 Rt0I99FYndqXp1s+xfFfK+F9Q8qgQsIPuYCHAqqGh1lxTsSs+TRbDd4dyovkO294fMEp LQ== 
Received: from mr2-mtap-s02.rno.apple.com (mr2-mtap-s02.rno.apple.com [17.179.226.134])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2vqy2h1cpj-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 21 Oct 2019 12:53:27 -0700
Received: from nwk-mmpp-sz10.apple.com
 (nwk-mmpp-sz10.apple.com [17.128.115.122]) by mr2-mtap-s02.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PZQ005NHPX1K610@mr2-mtap-s02.rno.apple.com>; Mon,
 21 Oct 2019 12:53:26 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz10.apple.com by
 nwk-mmpp-sz10.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PZQ00200PVUQ700@nwk-mmpp-sz10.apple.com>; Mon,
 21 Oct 2019 12:53:25 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 1288fa897f207fa8534ef4715f064d3d
X-Va-E-CD: 93f86fab608f4ce2f92478602106e721
X-Va-R-CD: a01ad3346a8f4a5cb1f06f0992e0d305
X-Va-CD: 0
X-Va-ID: 99ff1158-722c-4308-8abc-047b06903102
X-V-A:  
X-V-T-CD: 1288fa897f207fa8534ef4715f064d3d
X-V-E-CD: 93f86fab608f4ce2f92478602106e721
X-V-R-CD: a01ad3346a8f4a5cb1f06f0992e0d305
X-V-CD: 0
X-V-ID: b9354af0-4baa-4f4f-83b1-0917f68052bb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-10-21_05:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz10.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PZQ00JL3PUETCB0@nwk-mmpp-sz10.apple.com>; Mon,
 21 Oct 2019 12:51:50 -0700 (PDT)
Date:   Mon, 21 Oct 2019 12:51:50 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Jason Baron <jbaron@akamai.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
Message-id: <20191021195150.GA7514@MacBook-Pro-64.local>
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-21_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/19 - 14:27:24, Jason Baron wrote:
> 
> 
> On 10/21/19 2:02 PM, Yuchung Cheng wrote:
> > Thanks for the patch. Detailed comments below
> > 
> > On Fri, Oct 18, 2019 at 4:58 PM Neal Cardwell <ncardwell@google.com> wrote:
> >>
> >> On Fri, Oct 18, 2019 at 3:03 PM Jason Baron <jbaron@akamai.com> wrote:
> >>>
> >>> The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
> >>> or not data-in-SYN was ack'd on both the client and server side. We'd like
> >>> to gather more information on the client-side in the failure case in order
> >>> to indicate the reason for the failure. This can be useful for not only
> >>> debugging TFO, but also for creating TFO socket policies. For example, if
> >>> a middle box removes the TFO option or drops a data-in-SYN, we can
> >>> can detect this case, and turn off TFO for these connections saving the
> >>> extra retransmits.
> >>>
> >>> The newly added tcpi_fastopen_client_fail status is 2 bits and has 4
> >>> states:
> >>>
> >>> 1) TFO_STATUS_UNSPEC
> >>>
> >>> catch-all.
> >>>
> >>> 2) TFO_NO_COOKIE_SENT
> >>>
> >>> If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
> >>> was sent because we don't have one yet, its not in cache or black-holing
> >>> may be enabled (already indicated by the global
> >>> LINUX_MIB_TCPFASTOPENBLACKHOLE).
> > 
> > It'd be useful to separate the two that cookie is available but is
> > prohibited to use due to BH checking. We've seen users internally get
> > confused due to lack of this info (after seeing cookies from ip
> > metrics).
> > 
> 
> ok, yeah i had been thinking about splitting these out but thought that
> the LINUX_MIB_TCPFASTOPENBLACKHOLE counter could help differentiate
> these cases - but I'm ok making it explicit.
> 
> >>>
> >>> 3) TFO_NO_SYN_DATA
> >>>
> >>> Data was sent with SYN, we received a SYN/ACK but it did not cover the data
> >>> portion. Cookie is not accepted by server because the cookie may be invalid
> >>> or the server may be overloaded.
> >>>
> >>>
> >>> 4) TFO_NO_SYN_DATA_TIMEOUT
> >>>
> >>> Data was sent with SYN, we received a SYN/ACK which did not cover the data
> >>> after at least 1 additional SYN was sent (without data). It may be the case
> >>> that a middle-box is dropping data-in-SYN packets. Thus, it would be more
> >>> efficient to not use TFO on this connection to avoid extra retransmits
> >>> during connection establishment.
> >>>
> >>> These new fields certainly not cover all the cases where TFO may fail, but
> >>> other failures, such as SYN/ACK + data being dropped, will result in the
> >>> connection not becoming established. And a connection blackhole after
> >>> session establishment shows up as a stalled connection.
> >>>
> >>> Signed-off-by: Jason Baron <jbaron@akamai.com>
> >>> Cc: Eric Dumazet <edumazet@google.com>
> >>> Cc: Neal Cardwell <ncardwell@google.com>
> >>> Cc: Christoph Paasch <cpaasch@apple.com>
> >>> ---
> >>
> >> Thanks for adding this!
> >>
> >> It would be good to reset tp->fastopen_client_fail to 0 in tcp_disconnect().
> >>
> >>> +/* why fastopen failed from client perspective */
> >>> +enum tcp_fastopen_client_fail {
> >>> +       TFO_STATUS_UNSPEC, /* catch-all */
> >>> +       TFO_NO_COOKIE_SENT, /* if not in TFO_CLIENT_NO_COOKIE mode */
> >>> +       TFO_NO_SYN_DATA, /* SYN-ACK did not ack SYN data */
> >>
> >> I found the "TFO_NO_SYN_DATA" name a little unintuitive; it sounded to
> >> me like this means the client didn't send a SYN+DATA. What about
> >> "TFO_DATA_NOT_ACKED", or something like that?
> >>
> >> If you don't mind, it would be great to cc: Yuchung on the next rev.
> > TFO_DATA_NOT_ACKED is already available from the inverse of TCPI_OPT_SYN_DATA
> > #define TCPI_OPT_SYN_DATA       32 /* SYN-ACK acked data in SYN sent or rcvd */
> > 
> > It occurs (3)(4) are already available indirectly from
> > TCPI_OPT_SYN_DATA and tcpi_total_retrans together, but the socket must
> > query tcpi_total_retrans right after connect/sendto returns which may
> > not be preferred.
> > 
> > How about an alternative proposal to the types to catch more TFO issues:
> > 
> > TFO_STATUS_UNSPEC
> > TFO_DISABLED_BLACKHOLE_DETECTED
> > TFO_COOKIE_UNAVAILABLE
> > TFO_SYN_RETRANSMITTED  // use in conjunction w/ TCPI_OPT_SYN_DATA for (3)(4)
> 
> Ok, that set works for me. I will re-spin with these states for v2.
> Thanks for the suggestion!

Actually, longterm I hope we would be able to get rid of the
blackhole-detection and fallback heuristics. In a far distant future where
these middleboxes have been weeded out ;-)

So, do we really want to eternalize this as part of the API in tcp_info ?


Christoph

