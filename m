Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43CCA0A7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbfJCOyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:54:16 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:50512 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfJCOyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 10:54:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EF9DA68007A;
        Thu,  3 Oct 2019 14:54:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 3 Oct
 2019 07:53:52 -0700
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
 <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com> <87r23vq79z.fsf@toke.dk>
 <20191003105335.3cc65226@carbon>
 <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
Date:   Thu, 3 Oct 2019 15:53:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87pnjdq4pi.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24950.005
X-TM-AS-Result: No-3.444600-4.000000-10
X-TMASE-MatchedRID: hls5oAVArl/mLzc6AOD8DfHkpkyUphL9NACXtweanwblhO+RZsN0Zor+
        gPD/6bb5/nY12zbSW7Xh7WGk9eqElxMNizWX5cxi6OX7GFz9H1BGI9Mwxz8yaU8iLpubparm9Fb
        T0eFjvVY8trUk/Qn8GTleqRRlTHCdG7B2FtuHETsW8Al79bnAD/bXnlulH5Mg4PdcWsl+C/OMvr
        NL543EbgO3JVTdl8ePVIKZ9Pa/e17epncDgUbx3crLV1iI5YuZggDXESKHmTB+SLLtNOiBhkiO7
        +wNDdeYCqRokEHAs+3Y6rPzrnouFKPFjJEFr+olSXhbxZVQ5H/3FLeZXNZS4IzHo47z5Aa+5XAN
        8XFPmLn6ddQOm9Ik4J5glh4dZkrTAkfsSKHIw54MZCPlreuC10Wjf9EYkbqbj3rykoe+mOG9w8J
        o/nuKXT/IVSD45lqQ1DXsKeBNv04EqZlWBkJWd7MZNZFdSWvHG2wlTHLNY1JWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.444600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24950.005
X-MDID: 1570114455-tqQeZUSOc4Xy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2019 15:33, Toke Høiland-Jørgensen wrote:
> In all cases, the sysadmin can't (or doesn't want to) modify any of the
> XDP programs. In fact, they may just be installed as pre-compiled .so
> BPF files on his system. So he needs to be able to configure the call
> chain of different programs without modifying the eBPF program source
> code.
Perhaps I'm being dumb, but can't we solve this if we make linking work?
I.e. myIDS.so has ids_main() function, myFirewall.so has firewall()
 function, and sysadmin writes a little XDP prog to call these:

int main(struct xdp_md *ctx)
{
        int rc = firewall(ctx), rc2;

        switch(rc) {
        case XDP_DROP:
        case XDP_ABORTED:
        default:
                return rc;
        case XDP_PASS:
                return ids_main(ctx);
        case XDP_TX:
        case XDP_REDIRECT:
                rc2 = ids_main(ctx);
                if (rc2 == XDP_PASS)
                        return rc;
                return rc2;
        }
}

Now he compiles this and links it against those .so files, giving him
 a new object file which he can then install.

(One problem which does spring to mind is that the .so files may very
 inconsiderately both name their entry points main(), which makes
 linking against both of them rather challenging.  But I think that
 can be worked around with a sufficiently clever linker).

-Ed
