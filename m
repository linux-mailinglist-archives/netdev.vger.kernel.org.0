Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA11651C07B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357669AbiEENXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiEENW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:22:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE58542EC9;
        Thu,  5 May 2022 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WOqM4DKEC8qEB5Nc8Asp0yMdSAPt0BrvJUl7fGL2K2o=;
        t=1651756758; x=1652966358; b=VlPjU//FNXa2+XxsG73YHHulvZS9LU1Ok/2Gr9U1udS3ClE
        gggIn61BX96CpB7Ev+Na+syeXPKWxqroWgqIhhVP9CcvNs+ZUeF9ru4Hgk5+IJYQFsVqZ/jpcfF6b
        +cYxGWJCtu7d22kSwdnXxhbbkUvm0YOS0PSvMRyuLmd3/IUHs69f64s5/PkDAYh6/9dg+xKKoqLkL
        MK7v/u3ZQBkLUUCMZ8d2YxNKjC2UIKIbu17RYhSwkQTUP9KyJG8aVfpDoZD+Pj7tFfaRoDSTF49fC
        dWqQ6DUUZRcVUBWBnlwDbyxvb4M45fmuQnwHrqOAL+nt+iG9j3PRoD0+FZJ2Jyjg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nmbLD-002nmQ-2E;
        Thu, 05 May 2022 15:16:23 +0200
Message-ID: <970a674df04271b5fd1971b495c6b11a996c20c2.camel@sipsolutions.net>
Subject: Re: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        Christian =?ISO-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        keyrings@vger.kernel.org, kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nuno =?ISO-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Date:   Thu, 05 May 2022 15:16:19 +0200
In-Reply-To: <202205040819.DEA70BD@keescook>
References: <20220504014440.3697851-1-keescook@chromium.org>
         <20220504014440.3697851-3-keescook@chromium.org>
         <d3b73d80f66325fdfaf2d1f00ea97ab3db03146a.camel@sipsolutions.net>
         <202205040819.DEA70BD@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-04 at 08:38 -0700, Kees Cook wrote:
> 
> It seemed like requiring a structure be rearranged to take advantage of
> the "automatic layout introspection" wasn't very friendly. On the other
> hand, looking at the examples, most of them are already neighboring
> members. Hmmm.

A lot of them are, and many could be, though not all.

> > or so? The long and duplicated DECLARE_FLEX_ARRAY_ELEMENTS_COUNT and
> > DECLARE_FLEX_ARRAY_ELEMENTS seems a bit tedious to me, at least in cases
> > where the struct layout is not the most important thing (or it's already
> > at the end anyway).
> 
> The names aren't great, but I wanted to distinguish "elements" as the
> array not the count. Yay naming.

:-)

> However, perhaps the solution is to have _both_. i.e using
> BOUNDED_FLEX_ARRAY(count_type, count_name, array_type, array_name) for
> the "neighboring" case, and the DECLARE...{ELEMENTS,COUNT} for the
> "split" case.

Seems reasonable to me.

> And DECLARE_FLEX_ARRAY_ELEMENTS could actually be expanded to include
> the count_name too, so both methods could be "forward portable" to a
> future where C grew the syntax for bounded flex arrays.

I guess I don't see that happening :)

> > This seems rather awkward, having to set it to NULL, then checking rc
> > (and possibly needing a separate variable for it), etc.
> 
> I think the errno return is completely required. I had an earlier version
> of this that was much more like a drop-in replacement for memcpy that
> would just truncate or panic, 
> 

Oh, I didn't mean to imply it should truncate or panic or such - but if
it returns a pointer it can still be an ERR_PTR() or NULL instead of
having this separate indication, which even often confuses static type
checkers since they don't always see the "errno == 0 <=> ptr != NULL"
relation.

So not saying you shouldn't have any error return - clearly you need
that, just saying that I'm not sure that having the two separated is
great.


> Requiring instance to be NULL is debatable, but I feel pretty strongly
> about it because it does handle a class of mistakes (resource leaks),
> and it's not much of a burden to require a known-good starting state.

Yeah, dunno, I guess I'm slightly more on the side of not requiring it,
since we don't do the same for kmalloc() etc. and probably really
wouldn't want to add kmalloc_s() that does it ;-)

I mean, you _could_ go there:

int kmalloc_s(void **ptr, size_t size, gfp_t gfp)
{
  void *ret;

  if (*ptr)
    return -EINVAL;

  ret = kmalloc(size, gfp);
  if (!ret)
    return -ENOMEM;
  *ptr = ret;
  return 0;  
}

right? But we don't really do that, and I'm not sure it'd be a win if
done over the whole code base.

So I'm not really sure why this aspect here should need to be different,
except of course that you already need the input argument for the magic.

But we could still have (this prototype is theoretical, of course, it
cannot be implemented in C):

void *mem_to_flex_dup(void *ptr, const void *data, size_t elements,
                      gfp_t gfp);


which isn't really that much better though.

And btw, while I was writing it down I was looking to see if it should
be "size_t elements" or "size_t len" (like memcpy), it took me some time
to figure out, and I was looking at the examples:

 1) most of them actually use __u8 or some variant thereof, so you
    could probably add an even simpler macro like
       BOUNDED_FLEX_DATA(int, bytes, data)
    which has the u8 type internally.

 2) Unless I'm confusing myself, you got the firewire change wrong,
    because __mem_to_flex_dup takes the "elements_count", but the
    memcpy() there wasn't multiplied by the sizeof(element)? Or maybe
    the fact that it was declared as __u32 header[0] is wrong, and it
    should be __u8, but it's all very confusing, and I'm really not
    sure about this at all.



One "perhaps you'll laugh me out of the room" suggestion might be to
actually be able to initialize the whole thing too?


mydata = flex_struct_alloc(mydata, GFP_KERNEL,
                           variable_data, variable_len,
                           .member = 1,
                           .another = 2);

(the ordering can't really be otherwise since you have to use
__VA_ARGS__).

That might reduce some more code too, though I guess it's quite some
additional magic ... :)


> > but still, honestly, I don't like it. As APIs go, it feels a bit
> > cumbersome and awkward to use, and you really need everyone to use this,
> > and not say "uh what, I'll memcpy() instead".
> 
> Sure, and I have tried to get it down as small as possible. The earlier
> "just put all the member names in every call" version was horrid. :P

:-D

> I
> realize it's more work to check errno, but the memcpy() API we've all
> been trained to use is just plain dangerous. I don't think it's
> unreasonable to ask people to retrain themselves to avoid it. All that
> said, yes, I want it to be as friendly as possible.
> 
> > Maybe there should also be a realloc() version of it?
> 
> Sure! Seems reasonable. I'd like to see the code pattern for this
> though. Do you have any examples?

I was going to point to struct cfg80211_bss_ies, but I realize now
they're RCU-managed, so we never resize them anyway ... So maybe it's
less common than I thought it might be.

I suppose you know better since you converted a lot of stuff already :-)

johannes
