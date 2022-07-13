Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0801572E56
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiGMGlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiGMGlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:41:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A383DE19D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:41:05 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bp17so9671862lfb.3
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 23:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JoGmmC4JhA/Ubr31AGH16dS+hmrzbVzIoI58uz69fT0=;
        b=Oo3Tjn2gHp+o9qdhUOjhNk9oeFjKyINCdc+ua+0dionkJAu2022vWs2ei7oETKW3zA
         FIWbiB5PM6uZ32ONt55I89UW05KhJlB9EkJpcxEIH3UeZfEpQOWUuCFJMzRvfOZ0HxsC
         erdcW3pAX/J+5DKXOm+XskOaz/YBfJL4/EmiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JoGmmC4JhA/Ubr31AGH16dS+hmrzbVzIoI58uz69fT0=;
        b=1YB1SIz2a6TtEqdyBmShQIeCwz09zi1gf8FFEDIsdx1XhSJZoWhZqbBBIqNCMNY40Y
         KEvkNVMD6jFiNzfybh3RfxYtoqdjWrv2907AZWvX8+UrNE4suZnE3cVv/foPbM/pUoKv
         Ozd9HMPlQxcWPBzMqVYJ1WA6CADuDVqsWSh2JnTGu41egEfnrLsJBNoi+ZbR3M7kGIi8
         pkHA30F9H7KkVQ9vk52YpcJlH+TxYto+2hxbqP4UamL25FEpVGVU9Nt6BmQ1SH4o3pim
         Etl2iUEs48yDRPeJNnUb+SMDzxllKIL/Cp7gAeTnqR1dCeUb1KRPR/qRhMeSA82Z6PF/
         RdFA==
X-Gm-Message-State: AJIora97y3f701ZB4IEYIYeeZG3/5RA5IInLbTc73y7dOmcCUkdqvc3E
        me0s7dkfunU+SQY9rGOYqNEzdK28fql8LQ2CtfZ9TA==
X-Google-Smtp-Source: AGRyM1vQ97kBtPAAtADWSg+h2DT5I6apZZJah97aFrQY4kIYWm7D0gtdJ6jLpjZuVhVH0XjQlMr4jvcNslvZKtGrf6U=
X-Received: by 2002:ac2:4c15:0:b0:487:8ae9:7491 with SMTP id
 t21-20020ac24c15000000b004878ae97491mr1142942lfq.214.1657694462022; Tue, 12
 Jul 2022 23:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com> <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho> <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
 <Ys0UpFtcOGWjK/sZ@nanopsycho> <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
 <Ys24l4O1M/8Kf4/o@nanopsycho>
In-Reply-To: <Ys24l4O1M/8Kf4/o@nanopsycho>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Wed, 13 Jul 2022 12:10:50 +0530
Message-ID: <CAHLZf_tzpG9J=_orUsD9xto_Q818S-YqOTFvWchFjRkR3LXhvA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for selftests
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000093ba4e05e3aa11ce"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000093ba4e05e3aa11ce
Content-Type: text/plain; charset="UTF-8"

Hi Jiri,

On Tue, Jul 12, 2022 at 11:38 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, Jul 12, 2022 at 06:41:49PM CEST, vikas.gupta@broadcom.com wrote:
> >Hi Jiri,
> >
> >On Tue, Jul 12, 2022 at 11:58 AM Jiri Pirko <jiri@nvidia.com> wrote:
> >>
> >> Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
> >> >Hi Jiri,
> >> >
> >> >On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
> >> >
> >> >> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
>
> [...]
>
>
> >> >> >  * enum devlink_trap_action - Packet trap action.
> >> >> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
> >> >> is not
> >> >> >@@ -576,6 +598,10 @@ enum devlink_attr {
> >> >> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
> >> >> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
> >> >> >
> >> >> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
> >> >>
> >> >> I don't see why this is u32 bitset. Just have one attr per test
> >> >> (NLA_FLAG) in a nested attr instead.
> >> >>
> >> >
> >> >As per your suggestion, for an example it should be like as below
> >> >
> >> >        DEVLINK_ATTR_SELFTESTS,                 /* nested */
> >> >
> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
> >> >
> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */
> >>
> >> Yeah, but have the flags in separate enum, no need to pullute the
> >> devlink_attr enum by them.
> >>
> >>
> >> >
> >> >....    <SOME MORE TESTS>
> >> >
> >> >.....
> >> >
> >> >        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
> >> >
> >> >
> >> >
> >> > If we have this way then we need to have a mapping (probably a function)
> >> >for drivers to tell them what tests need to be executed based on the flags
> >> >that are set.
> >> > Does this look OK?
> >> >  The rationale behind choosing a mask is that we could directly pass the
> >> >mask-value to the drivers.
> >>
> >> If you have separate enum, you can use the attrs as bits internally in
> >> kernel. Add a helper that would help the driver to work with it.
> >> Pass a struct containing u32 (or u8) not to drivers. Once there are more
> >> tests than that, this structure can be easily extended and the helpers
> >> changed. This would make this scalable. No need for UAPI change or even
> >> internel driver api change.
> >
> >As per your suggestion, selftest attributes can be declared in separate
> >enum as below
> >
> >enum {
> >
> >        DEVLINK_SELFTEST_SOMETEST,         /* flag */
> >
> >        DEVLINK_SELFTEST_SOMETEST1,
> >
> >        DEVLINK_SELFTEST_SOMETEST2,
> >
> >....
> >
> >......
> >
> >        __DEVLINK_SELFTEST_MAX,
> >
> >        DEVLINK_SELFTEST_MAX = __DEVLINK_SELFTEST_MAX - 1
> >
> >};
> >Below  examples could be the flow of parameters/data from user to
> >kernel and vice-versa
> >
> >
> >Kernel to user for show command . Users can know what all tests are
> >supported by the driver. A return from kernel to user.
> >______
> >|NEST |
> >|_____ |TEST1|TEST4|TEST7|...
> >
> >
> >User to kernel to execute test: If user wants to execute test4, test8, test1...
> >______
> >|NEST |
> >|_____ |TEST4|TEST8|TEST1|...
> >
> >
> >Result Kernel to user execute test RES(u8)
> >______
> >|NEST |
> >|_____ |RES4|RES8|RES1|...
>
> Hmm, I think it is not good idea to rely on the order, a netlink library
> can perhaps reorder it? Not sure here.
>
> >
> >Results are populated in the same order as the user passed the TESTs
> >flags. Does the above result format from kernel to user look OK ?
> >Else we need to have below way to form a result format, a nest should
> >be made for <test_flag,
> >result> but since test flags are in different enum other than
> >devlink_attr and RES being part of devlink_attr, I believe it's not
> >good practice to make the below structure.
>
> Not a structure, no. Have it as another nest (could be the same attr as
> the parent nest:
>
> ______
> |NEST |
> |_____ |NEST|       |NEST|       |NEST|
>         TEST4,RES4   TEST8,RES8   TEST1, RES1
>
> also, it is flexible to add another attr if needed (like maybe result
> message string containing error message? IDK).

For above nesting we can have the attributes defined as below

Attribute in  devlink_attr
enum devlink_attr {
  ....
  ....
        DEVLINK_SELFTESTS_INFO, /* nested */
  ...
...
}

enum devlink_selftests {
        DEVLINK_SELFTESTS_SOMETEST0,   /* flag */
        DEVLINK_SELFTESTS_SOMETEST1,
        DEVLINK_SELFTESTS_SOMETEST2,
        ...
        ...
}

enum devlink_selftest_result {
        DEVLINK_SELFTESTS_RESULT,       /* nested */
        DEVLINK_SELFTESTS_TESTNUM,      /* u32  indicating the test
number in devlink_selftests enum */
        DEVLINK_SELFTESTS_RESULT_VAL,   /* u8  skip, pass, fail.. */
        ...some future attrr...

}
enums in devlink_selftest_result can be put in devlink_attr though.

Does this look OK?

Thanks,
Vikas

>
>
>
> >______
> >|NEST |
> >|_____ | TEST4, RES4|TEST8,RES8|TEST1,RES1|...
> >
> >Let me know if my understanding is correct.
>
> [...]

--00000000000093ba4e05e3aa11ce
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOxHuhUdp8j3QjOp6Klhk6NlFtjVDgmqvnSZ
oAZ24hgAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxMzA2
NDEwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAwVeswFgJaunz0w99n5YwQZPEl9RL5DmdbyOtwl081+QAuSZD/Nxai
nUxELe5Kh2MlP4HcI542n8vByFO9GhCf9WAUloc3D4fvRUjSwFjnVFxXXYpHVLwdwlyOg1h2/89J
ImDIB5yWh05K3VmHRkgenRaa/wOp9sQE6I/OXteApShTD3B3tyIuJMMzIrSdLwB7GOk3P9vcyInD
MZWOlWbNJ3/YG1U0hvTWd5xkutuxr7UM0ZDwqwRdJSMgx5+WXIGuD8eHwsDDZ3xnrLqTrNearFb2
5ZSYac7Q0luXqXqc/ZMav7qkg8sg+t2iy9xHT9nqM2xWGcexYYnicaisedeA
--00000000000093ba4e05e3aa11ce--
