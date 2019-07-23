Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5645B722ED
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfGWXXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:23:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41517 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfGWXXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:23:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so19903426pff.8
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 16:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iGk1ZQJK7n76nekLJVVrGKKED66IUtHbRBl1iCiE550=;
        b=FJgnflKGuWwE09vJB0hVmFbdcNP511PS9l8Jigd18767qcM1Cf1GynVo6SpgpzcF8L
         PjhE9YJ7hoTjhTLgNP0xnLeWzpCQa0PKFrKP85jSN/JgTZmzMqT+B2OkBHRATyvynpA+
         P4UHOmbSvDh8TbR9kylNeg+Z6ohZKEdhZkngFl2hRDPsIC42B29a86Gl79y3p/HX8Wx/
         i4/H22KtnYrfL9S+d/padU8E34aVx0nqIoMw+RPZru5kTYZTVBsXeO5AZPJuRO4DflgU
         FKcJXMU7cBlZMi7BZUh98GlajMOPPczVpd31O1aFGAP1kTK30n/NckqCYk+RZ0D7rS8K
         DxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGk1ZQJK7n76nekLJVVrGKKED66IUtHbRBl1iCiE550=;
        b=lM/72kXggQU6XjKpGxP1vmyFzBrCzXxvyEJkg4ay0lnCFqq9m0Ii5gD+2pUx+KrxVP
         wItSFrl9J+99dl+eCxB1oHEUAGZ6yWyxkpYUOl+PkxhQaeT0xGOzZLCRaXcKFAKr0fXc
         6b/eMuyg6gq/XT9eUf8sBXtVcNI/X+ITZjAijmIpSt8BltX39IYqIEcCONs4WsX9T2Ms
         NbYQqXsGjt16BBLSz4w1VodzLS1rZZiOfUEM29bnSrjLfYi2SAMQk3eRZWtGIfcoflZy
         392MXm37FBFK5wnKHgblr5jxGekpSOjATbUjY3pUKmI27gag4/l0nBVnQHL7UcAZ2x+p
         iKbA==
X-Gm-Message-State: APjAAAUddtwvyoFUbwzLfpez1+9zc3DBtqIY/pbY4qDGUQZI4BNCkS6n
        Ab7Fs0thmbtin8wynknvVqY=
X-Google-Smtp-Source: APXvYqx2N+y2HrXDn51GSQvi56fYbPwRhnjz2Phej7l80cjt3h6FzWGHnfKwqYTrMdcP4MpWKwCxYA==
X-Received: by 2002:a17:90a:8688:: with SMTP id p8mr85775874pjn.57.1563924215452;
        Tue, 23 Jul 2019 16:23:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j5sm37548126pgp.59.2019.07.23.16.23.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 16:23:35 -0700 (PDT)
Date:   Tue, 23 Jul 2019 16:23:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
Message-ID: <20190723162328.5182a843@hermes.lan>
In-Reply-To: <8BC34CA3-C500-4188-BDBA-4B2B7E9F1EE2@intel.com>
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
        <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
        <98A741A5-EAC0-408F-84C2-34E4714A2097@intel.com>
        <0e5fc2fe-dc83-b876-40ac-3b6f3f47bb29@gmail.com>
        <8BC34CA3-C500-4188-BDBA-4B2B7E9F1EE2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 21:34:46 +0000
"Patel, Vedang" <vedang.patel@intel.com> wrote:

> > On Jul 22, 2019, at 5:11 PM, David Ahern <dsahern@gmail.com> wrote:
> >=20
> > On 7/22/19 1:11 PM, Patel, Vedang wrote: =20
> >>=20
> >>  =20
> >>> On Jul 22, 2019, at 11:21 AM, David Ahern <dsahern@gmail.com> wrote:
> >>>=20
> >>> On 7/19/19 3:40 PM, Vedang Patel wrote: =20
> >>>> In iproute2 txtime-assist series, it was pointed out that print_bool=
()
> >>>> should be used to print binary values. This is to make it JSON frien=
dly.
> >>>>=20
> >>>> So, make the corresponding changes in ETF.
> >>>>=20
> >>>> Fixes: 8ccd49383cdc ("etf: Add skip_sock_check")
> >>>> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> >>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> >>>> ---
> >>>> tc/q_etf.c | 12 ++++++------
> >>>> 1 file changed, 6 insertions(+), 6 deletions(-)
> >>>>=20
> >>>> diff --git a/tc/q_etf.c b/tc/q_etf.c
> >>>> index c2090589bc64..307c50eed48b 100644
> >>>> --- a/tc/q_etf.c
> >>>> +++ b/tc/q_etf.c
> >>>> @@ -176,12 +176,12 @@ static int etf_print_opt(struct qdisc_util *qu=
, FILE *f, struct rtattr *opt)
> >>>> 		     get_clock_name(qopt->clockid));
> >>>>=20
> >>>> 	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
> >>>> -	print_string(PRINT_ANY, "offload", "offload %s ",
> >>>> -				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
> >>>> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
> >>>> -				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
> >>>> -	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
> >>>> -				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
> >>>> +	if (qopt->flags & TC_ETF_OFFLOAD_ON)
> >>>> +		print_bool(PRINT_ANY, "offload", "offload ", true);
> >>>> +	if (qopt->flags & TC_ETF_DEADLINE_MODE_ON)
> >>>> +		print_bool(PRINT_ANY, "deadline_mode", "deadline_mode ", true);
> >>>> +	if (qopt->flags & TC_ETF_SKIP_SOCK_CHECK)
> >>>> +		print_bool(PRINT_ANY, "skip_sock_check", "skip_sock_check", true);
> >>>>=20
> >>>> 	return 0;
> >>>> }
> >>>>  =20
> >>>=20
> >>> This changes existing output for TC_ETF_OFFLOAD_ON and
> >>> TC_ETF_DEADLINE_MODE_ON which were added a year ago. =20
> >> Yes, this is a good point. I missed that.=20
> >>=20
> >> Another idea is to use is_json_context() and call print_bool() there. =
But, that will still change values corresponding to the json output for the=
 above flags from =E2=80=9Con=E2=80=9D/=E2=80=9Coff=E2=80=9D to =E2=80=9Ctr=
ue=E2=80=9D/=E2=80=9Cfalse=E2=80=9D. I am not sure if this is a big issue.=
=20
> >>=20
> >> My suggestion is to keep the code as is. what do you think?
> >>  =20
> >=20
> > I think we need automated checkers for new code. ;-)
> >=20
> > The first 2 should not change for backward compatibility - unless there
> > is agreement that this feature is too new and long term it is better to
> > print as above.
> >=20
> > Then the new one should follow context of the other 2 - consistency IMHO
> > takes precedence. =20
> Thanks for the inputs.=20
>=20
> Let=E2=80=99s keep whatever is currently present upstream and you can ign=
ore this patch.
>=20
> Thanks,
> Vedang
Agreed. At this point consistency is better.
Maybe at some future point, all the JSON will be reviewed and fixed (yes it=
 would be a breaking flag day).
But for now inconsistent usage across ip, tc, and devlink is a fact of life.
