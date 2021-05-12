Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604E637B325
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 02:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhELAqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 20:46:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60468 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhELAqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 20:46:16 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210512004507epoutp01376d16c07d63c7be7d6f919c80545c29~_KxpO6pVK1031810318epoutp014
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 00:45:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210512004507epoutp01376d16c07d63c7be7d6f919c80545c29~_KxpO6pVK1031810318epoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620780307;
        bh=dfggp+4g/zAr9O+AzcgFCwUClokaZu0+FQs1KqAJUDg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=XA9RW9j343EQGsDvb6I7Pk2hS9Qmu1HOB3WvJHzaFcSlz+fsSm425BMgXqzaJQnb2
         f9n34GdW7IjPPaCLNROsKWB7kLOclO12Ae3r61zGUds5ponfBplwUZDEg3z4K6BaDp
         koUf7dc0ZJMeXgmVx0CUysUhca+xjYwkwDkasOWs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210512004507epcas2p268219b25083295c943dd87ba0e8fdf02~_KxoumdM70700007000epcas2p2c;
        Wed, 12 May 2021 00:45:07 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Ffx0167Gfz4x9Q2; Wed, 12 May
        2021 00:45:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.68.09433.0152B906; Wed, 12 May 2021 09:45:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210512004504epcas2p3e3dc9b5dc5df6ea16fb887e0fb23718c~_Kxl9Kbhf1310913109epcas2p3Z;
        Wed, 12 May 2021 00:45:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210512004504epsmtrp2c27fee30e1107570bdf11cc1e6972289~_Kxl8Bl4H0559905599epsmtrp2E;
        Wed, 12 May 2021 00:45:04 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-1e-609b2510bf9e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1C.05.08637.0152B906; Wed, 12 May 2021 09:45:04 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210512004504epsmtip15aec5dec4cde3de0795bff4ac6ee4d6f~_KxloXrmK0154401544epsmtip1Y;
        Wed, 12 May 2021 00:45:04 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'bpf'" <bpf@vger.kernel.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF=yD-+ncxKY28h8ch8kcJmSXfqdnBrBELKFBPmfP7RzNsWoTg@mail.gmail.com>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Wed, 12 May 2021 09:45:03 +0900
Message-ID: <01b701d746c8$0c15ae70$24410b50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMsBZavlXQIxNaIYAiru3ucBq8RF2QKY6vTDAm6kVlUBadK04AMaqQ3GARiLayQDE+caWwJJGwtFAeZKb9QDLW923AHUONYWAfw9g6SoAqstYA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmma6A6uwEg43TzSy+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hs2h4y2VxbIGYxc/D
        Z5gtFv/cAFS1ZAajA7/HlpU3mTwmNr9j99g56y67R8uRt6weXTcuMXtsWtXJ5vF5k1wAe1SO
        TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q2UoKZYk5
        pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScAkPDAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyM
        CdMOsRScF6z4eyuxgXE9bxcjJ4eEgInE5F1PmEFsIYEdjBLzb/l0MXIB2Z8YJf6v3sAC4Xxj
        lNh7q48JpqNryis2iI69jBITbhRBFL1glDh0bhJYEZuAlsSbWe2sILaIgJXE/9kn2EGKmAVO
        s0g8Wf0NrIhTIFBic98BsCJhgWCJp5OawOIsAqoSS3tBVnNy8ApYSvzbNJsJwhaUODnzCVic
        WUBeYvvbOcwQFylI/Hy6jBVkgYjAMkaJaX+nMUIUiUjM7myDKnrAIbHoiRGE7SJxecJ1dghb
        WOLV8S1QtpTE53d7gV7jALLrJVq7Y0BmSgj0MEpc2QexWELAWGLWs3ZGkBpmAU2J9bv0IcqV
        JY7cgjqNT6Lj8F92iDCvREebEISpJDHxSzzEDAmJFycns0xgVJqF5K9ZSP6aheT8WQirFjCy
        rGIUSy0ozk1PLTYqMEaO6U2M4PSs5b6DccbbD3qHGJk4GA8xSnAwK4nwzq2flSDEm5JYWZVa
        lB9fVJqTWnyI0RQY0hOZpUST84EZIq8k3tDUyMzMwNLUwtTMyEJJnPdnal2CkEB6Yklqdmpq
        QWoRTB8TB6dUA1N9Ln/Gh6fXjetYd/SUnNz3nUtY1u+F9hx3V0mThhOMW97f28Nq1l/5dXkp
        J+supxfJJ5XmHpO9EaYRVTvFTsZ77Zar7N+myF5xLroYPu2J0/3VT/7Ob6m76vvGVKrMXtmj
        N6J+SvwL39crnrcJ7I/buPBu9wL7rNu/C0X/Tt/D536I7ebvuNeLpsjZf4v0Z+r55mNfflEv
        271tcaz23sCIa285m/YIsRtJabz22/Q+9XDKm9iC1VYfLqVbtGoaiHkdWuj88P+PFGUWzZ2p
        11UNuKOO8ZX/6Oa/8Iypa9JuVofy2Uma3rn/Fx3tL/GImvxr8ymlCnFZo6QnDI8ULUU6OT+u
        FhecO1Vyqkb6OyWW4oxEQy3mouJEAKIla6xYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnK6A6uwEgzUHuCy+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hs2h4y2VxbIGYxc/D
        Z5gtFv/cAFS1ZAajA7/HlpU3mTwmNr9j99g56y67R8uRt6weXTcuMXtsWtXJ5vF5k1wAexSX
        TUpqTmZZapG+XQJXxoRph1gKzgtW/L2V2MC4nreLkZNDQsBEomvKK7YuRi4OIYHdjBLTT+0F
        cjiAEhISuza7QtQIS9xvOcIKUfOMUeLj76csIAk2AS2JN7PaWUFsEQErif+zT7CDFDELXGWR
        2PzjGzNExz4OiQsn3zCBVHEKBEps7jsA1iEMZPf/u8UIYrMIqEos7d0ANpVXwFLi36bZTBC2
        oMTJmU/A4swC2hK9D1sZIWx5ie1v5zBDnKcg8fPpMrDzRASWMUpM+zsNqkhEYnZnG/MERuFZ
        SGbNQjJrFpJZs5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyxWpo7GLev
        +qB3iJGJg/EQowQHs5II79z6WQlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnN
        Tk0tSC2CyTJxcEo1MLWpmM/aENMXZ55f5eKU9r+wrWXjEaOaEz+8e1I3Vy+zdlws1bbkh+Pj
        4yk51+o7fkvUMMx7uzVdQTdaVlKZJ8Xqbu3Jtl/Tzhy5pvTv5cfgC88erBe88MxiwVqmc9cS
        v95+HF91Vqq3y2NOYcH1f3Y9Gvef7Jv4/RxjU9bDv7Lue/5aW094EWrMsTV/+nLRHTtfLgxO
        6fr26GQX0wZphUMzzp9ZIFzyvk+lqnTj1fmFcy+WdTxnDJ4VIuv233yDn2jGu8iz+nMeTLnw
        d2bUfJV6uf1Zli2O1Z8E5/5P+PpDQG71kc9bVoWH2oZOX/D7+M9lB84zq/LN2ud5zOfJjXZZ
        14nmp6tf6wZX/Xy8VKdeiaU4I9FQi7moOBEAVTXzjEcDAAA=
X-CMS-MailID: 20210512004504epcas2p3e3dc9b5dc5df6ea16fb887e0fb23718c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
        <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
        <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
        <02c801d7421f$65287a90$2f796fb0$@samsung.com>
        <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
        <001801d742db$68ab8060$3a028120$@samsung.com>
        <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
        <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com>
        <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
        <007001d7431a$96281960$c2784c20$@samsung.com>
        <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
        <00c901d74543$57fa3620$07eea260$@samsung.com>
        <CA+FuTSepShKoXUJo7ELMMJ4La11J6CsZggJWsQ5MB2_uhAi+OQ@mail.gmail.com>
        <CA+FuTSeyuUvKC==Mo7L+u3PS0BQyea+EdLLYjhGFrP7FQZsbEQ@mail.gmail.com>
        <015101d74602$86442210$92cc6630$ @samsung.com> 
        <CAF=yD-+ncxKY28h8ch8kcJmSXfqdnBrBELKFBPmfP7RzNsWoTg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 01:38:41PM -0400, Willem de Bruijn wrote:
> On Mon, May 10, 2021 at 9:11 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >
> > On Mon, May 10, 2021 at 09:46:25AM -0400, Willem de Bruijn wrote:
> > > On Mon, May 10, 2021 at 9:19 AM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > > > That generates TCP packets with different MSS within the same stream.
> > > > > >
> > > > > > My suggestion remains to just not change MSS at all. But this has to
> > > > > > be a new flag to avoid changing established behavior.
> > > > >
> > > > > I don't understand why the mss size should be kept in GSO step. Will
> > > > > there be any issue with different mss?
> > > >
> > > > This issue has come up before and that has been the feedback from
> > > > TCP experts at one point.
> > > >
> > > > > In general, upgrading mss make sense when 6 to 4. The new flag would be
> > > > > set by user to not change mss. What happened if user does not set the
> > > > > flag? I still think we should fix the issue with a general approach. Or
> > > > > can we remove the skb_increase_gso_size line?
> > > >
> > > > Admins that insert such BPF packets should be aware of these issues.
> > > > And likely be using clamping. This is a known issue.
> > > >
> > > > We arrived that the flag approach in bpf_skb_net_shrink. Extending
> > > > that  to bpf_skb_change_proto would be consistent.
> > >
> > > As for more generic approach: does downgrading to non-TSO by clearing
> > > gso_size work for this edge case?
> >
> > It can hit __skb_linearize in validate_xmit_skb and frags will be
> > copied to a linear part. The linear part size can exceed the MTU of
> > skb->dev unexpectedly.
> 
> When does skb_needs_linearize return true here (besides lack of
> scatter-gather support, which would also preclude TSO)?

As I know not every netdev support NETIF_F_SG. TSO requires SG.

    /* TSO requires that SG is present as well. */
    if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
        netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
        features &= ~NETIF_F_ALL_TSO;
    }

> 
> > I will make another patch with the flag approach.
> >

