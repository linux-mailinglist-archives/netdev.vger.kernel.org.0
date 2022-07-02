Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DA95641E9
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiGBRku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 13:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiGBRkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 13:40:49 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CEDE037;
        Sat,  2 Jul 2022 10:40:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 603A067400C9;
        Sat,  2 Jul 2022 19:40:40 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat,  2 Jul 2022 19:40:38 +0200 (CEST)
Received: from localhost.kfki.hu (host-94-248-211-146.kabelnet.hu [94.248.211.146])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 9BD6767400C7;
        Sat,  2 Jul 2022 19:40:35 +0200 (CEST)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id 4FA9F3C1C41; Sat,  2 Jul 2022 19:40:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id 4D60D3C1789;
        Sat,  2 Jul 2022 19:40:35 +0200 (CEST)
Date:   Sat, 2 Jul 2022 19:40:35 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "U'ren, Aaron" <Aaron.U'ren@sony.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
In-Reply-To: <20220630110443.100f8aa9@kernel.org>
Message-ID: <d44d3522-ac1f-a1e-ddf6-312c7b25d685@netfilter.org>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com> <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info> <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info> <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info> <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com> <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info> <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
 <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info> <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com> <20220630110443.100f8aa9@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1126082976-1656783635=:2522"
X-deepspam: 20ham 14%
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1126082976-1656783635=:2522
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 30 Jun 2022, Jakub Kicinski wrote:

> Sounds like you're pretty close to figuring this out! Can you check=20
> if the user space is intentionally setting IPSET_ATTR_INITVAL?
> Either that or IPSET_ATTR_GC was not as "unused" as initially thought.

IPSET_ATTR_GC was really unused. It was an old remnant from the time when=
=20
ipset userspace-kernel communication was through set/getsockopt. However,=
=20
when it was migrated to netlink, just the symbol was kept but it was not=20
used either with the userspace tool or the kernel.

Aaron, could you send me how to reproduce the issue? I have no idea how=20
that patch could be the reason. Setting/getting/using IPSET_ATTR_INITVAL=20
is totally independent from listing iptables rules. But if you have got a=
=20
reproducer then I can dig into it.

Best regards,
Jozsef

> Testing something like this could be a useful data point:
>=20
> diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi=
/linux/netfilter/ipset/ip_set.h
> index 6397d75899bc..7caf9b53d2a7 100644
> --- a/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -92,7 +92,7 @@ enum {
>  	/* Reserve empty slots */
>  	IPSET_ATTR_CADT_MAX =3D 16,
>  	/* Create-only specific attributes */
> -	IPSET_ATTR_INITVAL,	/* was unused IPSET_ATTR_GC */
> +	IPSET_ATTR_GC,
>  	IPSET_ATTR_HASHSIZE,
>  	IPSET_ATTR_MAXELEM,
>  	IPSET_ATTR_NETMASK,
> @@ -104,6 +104,8 @@ enum {
>  	IPSET_ATTR_REFERENCES,
>  	IPSET_ATTR_MEMSIZE,
> =20
> +	IPSET_ATTR_INITVAL,
> +
>  	__IPSET_ATTR_CREATE_MAX,
>  };
>  #define IPSET_ATTR_CREATE_MAX	(__IPSET_ATTR_CREATE_MAX - 1)
>=20
>=20
> On Thu, 30 Jun 2022 14:59:14 +0000 U'ren, Aaron wrote:
> > Thorsten / Jozsef -
> >=20
> > Thanks for continuing to follow up! I'm sorry that this has moved so =
slow, it has taken us a bit to find the time to fully track this issue do=
wn, however, I think that we have figured out enough to make some more fo=
rward progress on this issue.
> >=20
> > Jozsef, thanks for your insight into what is happening between those =
system calls. In regards to your question about wait/wound mutex debuggin=
g possibly being enabled, I can tell you that we definitely don't have th=
at enabled on any of our regular machines. While we were debugging we did=
 turn on quite a few debug options to help us try and track this issue do=
wn and it is very possible that the strace that was taken that started of=
f this email was taken on a machine that did have that debug option enabl=
ed. Either way though, the root issue occurs on hosts that definitely do =
not have wait/wound mutex debugging enabled.
> >=20
> > The good news is that we finally got one of our development environme=
nts into a state where we could reliably reproduce the performance issue =
across reboots. This was a win because it meant that we were able to do a=
 full bisect of the kernel and were able to tell relatively quickly wheth=
er or not the issue was present in the test kernels.
> >=20
> > After bisecting for 3 days, I have been able to narrow it down to a s=
ingle commit: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/li=
nux.git/commit/?id=3D3976ca101990ca11ddf51f38bec7b86c19d0ca6f (netfilter:=
 ipset: Expose the initval hash parameter to userspace)
> >=20
> > I'm at a bit of a loss as to why this would cause such severe perform=
ance regressions, but I've proved it out multiple times now. I've even ch=
ecked out a fresh version of the 5.15 kernel that we've been deploying wi=
th just this single commit reverted and found that the performance proble=
ms are completely resolved.
> >=20
> > I'm hoping that maybe Jozsef will have some more insight into why thi=
s seemingly innocuous commit causes such larger performance issues for us=
? If you have any additional patches or other things that you would like =
us to test I will try to leave our environment in its current state for t=
he next couple of days so that we can do so.
> >=20
> > -Aaron
> >=20
> > From: Thorsten Leemhuis <regressions@leemhuis.info>
> > Date: Monday, June 20, 2022 at 2:16 AM
> > To: U'ren, Aaron <Aaron.U'ren@sony.com>
> > Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pab=
lo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.=
kernel.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <man=
uel.rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.ker=
nel.org>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Flor=
ian Westphal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.o=
rg>, Jozsef Kadlecsik <kadlec@netfilter.org>
> > Subject: Re: Intermittent performance regression related to ipset bet=
ween 5.10 and 5.15
> > On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> > > On Mon, 30 May 2022, Thorsten Leemhuis wrote: =20
> > >> On 04.05.22 21:37, U'ren, Aaron wrote: =20
> >  [...] =20
> > >=20
> > > Every set lookups behind "iptables" needs two getsockopt() calls: y=
ou can=20
> > > see them in the strace logs. The first one check the internal proto=
col=20
> > > number of ipset and the second one verifies/gets the processed set =
(it's=20
> > > an extension to iptables and therefore there's no internal state to=
 save=20
> > > the protocol version number). =20
> >=20
> > Hi Aaron! Did any of the suggestions from Jozsef help to track down t=
he
> > root case? I have this issue on the list of tracked regressions and
> > wonder what the status is. Or can I mark this as resolved?
> >=20
> > Side note: this is not a "something breaks" regressions and it seems =
to
> > progress slowly, so I'm putting it on the backburner:
> >=20
> > #regzbot backburner: performance regression where the culprit is hard=
 to
> > track down
> >=20
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' h=
at)
> >=20
> > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > reports and sometimes miss something important when writing mails lik=
e
> > this. If that's the case here, don't hesitate to tell me in a public
> > reply, it's in everyone's interest to set the public record straight.
> >=20
> >  [...] =20
> > >=20
> > > In your strace log
> > >=20
> > > 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0=
", [8]) =3D 0 <0.000024>
> > > 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0=
KUBE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> > > 0.109456 close(4)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.000022>
> > >=20
> > > the only things which happen in the second sockopt function are to =
lock=20
> > > the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare th=
e=20
> > > setname, save the result in the case of a match and unlock the mute=
x.=20
> > > Nothing complicated, no deep, multi-level function calls. Just a fe=
w line=20
> > > of codes which haven't changed.
> > >=20
> > > The only thing which can slow down the processing is the mutex hand=
ling.=20
> > > Don't you have accidentally wait/wound mutex debugging enabled in t=
he=20
> > > kernel? If not, then bisecting the mutex related patches might help=
.
> > >=20
> > > You wrote that flushing tables or ipsets didn't seem to help. That=20
> > > literally meant flushing i.e. the sets were emptied but not destroy=
ed? Did=20
> > > you try both destroying or flushing?
> > >  =20
> > >> Jozsef, I still have this issue on my list of tracked regressions =
and it
> > >> looks like nothing happens since above mail (or did I miss it?). C=
ould
> > >> you maybe provide some guidance to Aaron to get us all closer to t=
he
> > >> root of the problem? =20
> > >=20
> > > I really hope it's an accidentally enabled debugging option in the =
kernel.=20
> > > Otherwise bisecting could help to uncover the issue.
> > >=20
> > > Best regards,
> > > Jozsef
> > >  =20
> > >> P.S.: As the Linux kernel's regression tracker I deal with a lot o=
f
> > >> reports and sometimes miss something important when writing mails =
like
> > >> this. If that's the case here, don't hesitate to tell me in a publ=
ic
> > >> reply, it's in everyone's interest to set the public record straig=
ht.
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--8323328-1126082976-1656783635=:2522--
